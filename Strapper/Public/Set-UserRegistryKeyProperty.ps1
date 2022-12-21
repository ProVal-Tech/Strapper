function Set-UserRegistryKeyProperty {
    <#
    .SYNOPSIS
        Creates or updates a registry property value for existing user registry hives.
    .EXAMPLE
        Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Prompter" -Name "Timestamp" -Value 1
        Creates or updates a Dword registry property property for each available user's registry hive to a value of 1.
    .EXAMPLE
        Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Strings\New\Path" -Name "MyString" -Value "1234" -Force
        Creates or updates a String registry property based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.
    .EXAMPLE
        Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Strings\New\Path" -Username 'spike.spiegel' -Name "MyString" -Value "1234" -Force
        Creates or updates a String registry property for the local user 'spike.spiegel' based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.
    .EXAMPLE
        Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Strings\New\Path" -Username 'BEBOP\faye.valentine' -Name "MyString" -Value "1234" -Force
        Creates or updates a String registry property for the domain user 'faye.valentine' based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.
    .PARAMETER Path
        The relative registry path to the target property.
    .PARAMETER Username
        The user to target for editing.
        Should be in the format: <Domain Short Name or Hostname>\Username. If the domain and hostname are omitted, local user targeting will be assumed.
    .PARAMETER Name
        The name of the property to target.
    .PARAMETER Value
        The value to set on the target property.
    .PARAMETER Type
        The type of value to set. If not passed, this will be inferred from the object type of the Value parameter.
    .PARAMETER ExcludeDefault
        Exclude the Default user template from having the registry keys set.
    .PARAMETER Force
        Will create the registry key path to the property if it does not exist.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$Username,

        [Parameter(Mandatory = $false)]
        [string]$Name = '(Default)',

        [Parameter(Mandatory = $true)]
        [object]$Value,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Unknown', 'String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'QWord', 'None')]
        [Microsoft.Win32.RegistryValueKind]$Type,

        [Parameter(Mandatory = $false)]
        [switch]$ExcludeDefault,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }

    # Regex pattern for SIDs
    $patternSID = '((S-1-5-21)|(S-1-12-1))-\d+-\d+\-\d+\-\d+$'

    # Get Username, SID, and location of ntuser.dat for all users
    $profileList = Get-RegistryHivePath -ExcludeDefault:$ExcludeDefault

    # Get all user SIDs found in HKEY_USERS (ntuser.dat files that are loaded)
    $loadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object { $_.PSChildname -match $PatternSID } | Select-Object @{name = 'SID'; expression = { $_.PSChildName } }

    # Get all user hives that are not currently logged in
    if ($LoadedHives) {
        $UnloadedHives = Compare-Object $ProfileList.SID $LoadedHives.SID | Select-Object @{name = 'SID'; expression = { $_.InputObject } }, UserHive, Username
    } else {
        $UnloadedHives = $ProfileList
    }
    if ($Username) {
        if($Username -notmatch "\\") {
            $Username = "$env:COMPUTERNAME\$Username"
        }
        $profileList = $profileList | Where-Object { $_.Username -eq $Username }
    }
    # Iterate through each profile on the machine
    $returnEntries = @(
        foreach ($profile in $ProfileList) {
            # Load User ntuser.dat if it's not already loaded
            if ($profile.SID -in $UnloadedHives.SID) {
                reg load HKU\$($profile.SID) $($profile.UserHive) | Out-Null
            }

            $propertyPath = "Registry::HKEY_USERS\$($profile.SID)\$Path"

            # Set the parameters to pass to Set-RegistryKeyProperty
            $parameters = @{
                Path = $propertyPath
                Name = $Name
                Value = $Value
                Force = $Force
            }
            if ($Type) { $parameters.Add('Type', $Type) }

            # Set the target registry entry
            $returnEntry = Set-RegistryKeyProperty @parameters | Select-Object -ExpandProperty $Name

            # If the set was successful, then pass back the return entry from Set-RegistryKeyProperty
            if ($returnEntry) {
                [PSCustomObject]@{
                    Username = $profile.Username
                    SID = $profile.SID
                    Path = $propertyPath
                    Hive = $profile.UserHive
                    Name = $Name
                    Value = $returnEntry
                }
            } else {
                Write-Log -Text "Failed to set the requested registry entry for user '$($profile.Username)'" -Type WARN
            }

            # Collect garbage and close ntuser.dat if the hive was initially unloaded
            if ($profile.SID -in $UnloadedHives.SID) {
                [gc]::Collect()
                reg unload HKU\$($profile.SID) | Out-Null
            }
        }
    )
    Write-Log -Text "$($returnEntries.Count) user registry entries successfully updated."
    return $returnEntries
}
# SIG # Begin signature block
# MIInbwYJKoZIhvcNAQcCoIInYDCCJ1wCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBLrT5rSTjqg9gv
# Teq0DWupFtN/snM8RbT9ZnWC3I2dVqCCILYwggXYMIIEwKADAgECAhEA5CcElfaM
# kdbQ7HtJTqTfHDANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJQTDEiMCAGA1UE
# ChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEnMCUGA1UECxMeQ2VydHVtIENl
# cnRpZmljYXRpb24gQXV0aG9yaXR5MSIwIAYDVQQDExlDZXJ0dW0gVHJ1c3RlZCBO
# ZXR3b3JrIENBMB4XDTE4MDkxMTA5MjY0N1oXDTIzMDkxMTA5MjY0N1owfDELMAkG
# A1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMRAwDgYDVQQHDAdIb3VzdG9uMRgwFgYD
# VQQKDA9TU0wgQ29ycG9yYXRpb24xMTAvBgNVBAMMKFNTTC5jb20gUm9vdCBDZXJ0
# aWZpY2F0aW9uIEF1dGhvcml0eSBSU0EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQD5D92jK33L0Cr+7GeFpucuG7p34eP1r6Ts+kpdkcRXR2sYd2t28v2T
# 5D0PwhaeC2bDVpSeF4OFzlbv8hb9AGL1IglU6GUXTkG54E9Gl6obyLhuYl5psV/b
# KgJ+/GzK80HY7dDo/D9hSO2wAxQdEA5LGeC7TuyGZf82815nAgudhlVh/Xo47f7i
# GQC3b6FQYnV0PKD6yCWStG56Isf4HqHjst2RMasrHQT/pUoEN+mFpDMr/eLWVTR8
# GaRKaMeyqNO3yqGTiOvBl7yM+R3ZIoQkdMcEPWqpKZPM67hb4f5fJao0WMjBI1Sd
# G5gRwzicfj2GbKUPQIZ8AvRcAk8oy65xnw86yDP+ESU16vy6xWA92XwY1bKp03V4
# A3IiyjrDH+8s5S6p+p4stlFG/a8D1upgaOqFFjZrhekewLPdxCTcgCqBQW2UPsjg
# yYFBAJ5ev3/FCJiiGCxCQLP5bzgnS06A9D2BR+CIfOoczrV1XFEuHCt/GnIo5wC1
# 0XTG1+SfrQeTtlM1Nfw35MP2XRa+IXPekgr4oGNqvJaSaj74vGVVm971DYkmBPwl
# GqYlacvCbcp84llfl6zr7y7IvNcbWTwrzPIZyJNrJ2MZz/zpJvjKcZt/k/40Z4RO
# mev8s3gJM3C6ZqZ27Rtz6xqlDcQiEyCUVgpOLGxOsf3PnAm6ojPthwIDAQABo4IB
# UTCCAU0wEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4EFgQU3QQJB6L1en1SUxKS
# le44gCUNplkwHwYDVR0jBBgwFoAUCHbNywf/JPbFze27kLzihDdGdfcwDgYDVR0P
# AQH/BAQDAgEGMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9zc2xjb20uY3JsLmNl
# cnR1bS5wbC9jdG5jYS5jcmwwcwYIKwYBBQUHAQEEZzBlMCkGCCsGAQUFBzABhh1o
# dHRwOi8vc3NsY29tLm9jc3AtY2VydHVtLmNvbTA4BggrBgEFBQcwAoYsaHR0cDov
# L3NzbGNvbS5yZXBvc2l0b3J5LmNlcnR1bS5wbC9jdG5jYS5jZXIwOgYDVR0gBDMw
# MTAvBgRVHSAAMCcwJQYIKwYBBQUHAgEWGWh0dHBzOi8vd3d3LmNlcnR1bS5wbC9D
# UFMwDQYJKoZIhvcNAQELBQADggEBAB+VmiNU7oXC89RvuekEj0Z/LPcywKdDrAcA
# 7eCpRS39F+HtAEDIr5is9cAZrRuglzBAbOxb+6OTToyJYht88Dpfp0LPWMp1ZZwi
# TL92e5iTnBWDM7EO3FE4h3yVnBJplB4AeHR+3MAGd7pwLYcs12id47qFrUnzj2S0
# FQaDksaXpECTi63xZ5S0uVpnVDyoG9kFz+Sk+YgSAAaIJYXUXu7zk1fWgfgsrvf1
# UUirtmI6edvsLvI/FFY6yNnLpKJPJajRm6stMCBQBxpv8fGUHTmDY+gf/UnQ6B1G
# skaCJr2cneGiaEFIUW56/DWW9FTSvCtE5UfXd4KlSqtflzOrJBEwggZyMIIEWqAD
# AgECAghkM1HTxzifCDANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzEOMAwG
# A1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xGDAWBgNVBAoMD1NTTCBDb3Jw
# b3JhdGlvbjExMC8GA1UEAwwoU1NMLmNvbSBSb290IENlcnRpZmljYXRpb24gQXV0
# aG9yaXR5IFJTQTAeFw0xNjA2MjQyMDQ0MzBaFw0zMTA2MjQyMDQ0MzBaMHgxCzAJ
# BgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
# A1UECgwIU1NMIENvcnAxNDAyBgNVBAMMK1NTTC5jb20gQ29kZSBTaWduaW5nIElu
# dGVybWVkaWF0ZSBDQSBSU0EgUjEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCfgxNzqrDGbSHL24t6h3TQcdyOl3Ka5LuINLTdgAPGL0WkdJq/Hg9Q6p5t
# ePOf+lEmqT2d0bKUVz77OYkbkStW72fL5gvjDjmMxjX0jD3dJekBrBdCfVgWQNz5
# 1ShEHZVkMGE6ZPKX13NMfXsjAm3zdetVPW+qLcSvvnSsXf5qtvzqXHnpD0OctVIF
# D+8+sbGP0EmtpuNCGVQ/8y8Ooct8/hP5IznaJRy4PgBKOm8yMDdkHseudQfYVdIY
# yQ6KvKNc8HwKp4WBwg6vj5lc02AlvINaaRwlE81y9eucgJvcLGfE3ckJmNVz68Qh
# o+Uyjj4vUpjGYDdkjLJvSlRyGMwnh/rNdaJjIUy1PWT9K6abVa8mTGC0uVz+q0O9
# rdATZlAfC9KJpv/XgAbxwxECMzNhF/dWH44vO2jnFfF3VkopngPawismYTJboFbl
# SSmNNqf1x1KiVgMgLzh4gL32Bq5BNMuURb2bx4kYHwu6/6muakCZE93vUN8BuvIE
# 1tAx3zQ4XldbyDgeVtSsSKbt//m4wTvtwiS+RGCnd83VPZhZtEPqqmB9zcLlL/Hr
# 9dQg1Zc0bl0EawUR0tOSjAknRO1PNTFGfnQZBWLsiePqI3CY5NEv1IoTGEaTZeVY
# c9NMPSd6Ij/D+KNVt/nmh4LsRR7Fbjp8sU65q2j3m2PVkUG8qQIDAQABo4H7MIH4
# MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU3QQJB6L1en1SUxKSle44gCUN
# plkwMAYIKwYBBQUHAQEEJDAiMCAGCCsGAQUFBzABhhRodHRwOi8vb2NzcHMuc3Ns
# LmNvbTARBgNVHSAECjAIMAYGBFUdIAAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwOwYD
# VR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNvbS9zc2wuY29tLXJzYS1S
# b290Q0EuY3JsMB0GA1UdDgQWBBRUwv4QlQCTzWr158DX2bJLuI8M4zAOBgNVHQ8B
# Af8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAPUPJodwr5miyvXWyfCNZj05gtOI
# I9iCv49UhCe204MH154niU2EjlTRIO5gQ9tXQjzHsJX2vszqoz2OTwbGK1mGf+tz
# G8rlQCbgPW/M9r1xxs19DiBAOdYF0q+UCL9/wlG3K7V7gyHwY9rlnOFpLnUdTsth
# HvWlM98CnRXZ7WmTV7pGRS6AvGW+5xI+3kf/kJwQrfZWsqTU+tb8LryXIbN2g9KR
# +gZQ0bGAKID+260PZ+34fdzZcFt6umi1s0pmF4/n8OdX3Wn+vF7h1YyfE7uVmhX7
# eSuF1W0+Z0duGwdc+1RFDxYRLhHDsLy1bhwzV5Qe/kI0Ro4xUE7bM1eV+jjk5hLb
# q1guRbfZIsr0WkdJLCjoT4xCPGRo6eZDrBmRqccTgl/8cQo3t51Qezxd96JSgjXk
# tefTCm9r/o35pNfVHUvnfWII+NnXrJlJ27WEQRQu9i5gl1NLmv7xiHp0up516eDa
# p8nMLDt7TAp4z5T3NmC2gzyKVMtODWgqlBF1JhTqIDfM63kXdlV4cW3iSTgzN9vk
# bFnHI2LmvM4uVEv9XgMqyN0eS3FE0HU+MWJliymm7STheh2ENH+kF3y0rH0/NVjL
# w78a3Z9UVm1F5VPziIorMaPKPlDRADTsJwjDZ8Zc6Gi/zy4WZbg8Zv87spWrmo2d
# zJTw7XhQf+xkR6OdMIIGdjCCBF6gAwIBAgIQeVwkxuz4snsBAPX7/vbayDANBgkq
# hkiG9w0BAQsFADB4MQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNV
# BAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBDb3JwMTQwMgYDVQQDDCtTU0wuY29t
# IENvZGUgU2lnbmluZyBJbnRlcm1lZGlhdGUgQ0EgUlNBIFIxMB4XDTIyMDkwODE4
# MTExNloXDTIzMDkwNzE4MTExNlowfzELMAkGA1UEBhMCVVMxEDAOBgNVBAgMB0Zs
# b3JpZGExGjAYBgNVBAcMEUFsdGFtb250ZSBTcHJpbmdzMSAwHgYDVQQKDBdQcm92
# YWwgVGVjaG5vbG9naWVzIEluYzEgMB4GA1UEAwwXUHJvdmFsIFRlY2hub2xvZ2ll
# cyBJbmMwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQC8rFgT0frNYMOu
# jhP3zY5GLj2hndjE1m5UiIUtUXJ0N/X+U7ZzplXEAOrEifqApdBlTrCicq4G5qwk
# 8UV6q0gU6tDxiL8IUHNf6716MTLZuTr08gdLWY6t75Pi8JYz9FtgyiMNB8mo22MY
# 9DpBrW+uNCEO7hZP/siq+rRgroeyn8ClmKrlEvNXHIprqkaE/jBgmVWai3OrwMfK
# 7G7o0MMBAgIoIzyHBWD4nB4Bk66IbAyY6C3ORwBrpgzfT51+/yv2aEKbuZllTRRx
# pjFohqC02BYNrltAnypTO7lWdTWyfl/aTyY93kubWVJMrw5V7aQkbjtZuJUMO3uY
# DmDc8bw3kRYfT/ygA4RZBGkwWNrwOUR2XgOFjK4374jzpa/JW6TaU/v9espLB7RL
# YoUwKONPyMTEE5cBJOK91IwBeoeib0SSYadvtC2VxhaViB12il3mgOxP14o/ckRL
# 4sL3oiABqpYsPgBK0tq6We+JVyX+9GF2Gkje3Gc4jO+1s/B3cNECAwEAAaOCAXMw
# ggFvMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUVML+EJUAk81q9efA19myS7iP
# DOMwWAYIKwYBBQUHAQEETDBKMEgGCCsGAQUFBzAChjxodHRwOi8vY2VydC5zc2wu
# Y29tL1NTTGNvbS1TdWJDQS1Db2RlU2lnbmluZy1SU0EtNDA5Ni1SMS5jZXIwUQYD
# VR0gBEowSDAIBgZngQwBBAEwPAYMKwYBBAGCqTABAwMBMCwwKgYIKwYBBQUHAgEW
# Hmh0dHBzOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeTATBgNVHSUEDDAKBggrBgEF
# BQcDAzBNBgNVHR8ERjBEMEKgQKA+hjxodHRwOi8vY3Jscy5zc2wuY29tL1NTTGNv
# bS1TdWJDQS1Db2RlU2lnbmluZy1SU0EtNDA5Ni1SMS5jcmwwHQYDVR0OBBYEFOAY
# zCQ+hpcdCmsNYDdqF4DvoC5DMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsF
# AAOCAgEASHm1T/O4wAemUn5bAfQSnWz4raO9XPSwWytQqjMadSyCTqnz/uO37+dd
# sYBnla323Abl/7zV73Tg2dYDy4yM9W9MxL9Z3aylngcRI7cz4A/262ny2pRrjY3Y
# NSNeM1q4eGBXsMb2bqKVE1dZ9g9qSk+LpLOpExEpH4mvZjjjrUL0kQhlvytSDWpI
# QiZgIYI7JFW7TUXCdNtjnRLhqIJ08sfygk4tduO10XRC4NpxXeZEeqoU8EpW8Jfr
# IRH5zg/rWVygCltSHLkVaGk0jpWrLZCDmquG9CohhNdAPG2PMhZdAlijafyeg5YH
# zvK56qmWZvGemVbRK/TOXCh8UZNK3DjDT8ouylTe1Y0rG6Ml9yX7rBHaOu3seiiJ
# 5o/mWfse8KR57nQ584kkL3qACm9WV2WmVPRQKWeziv9CsQzilVKMshBlQDqNYIAf
# oIaIduQjQoXjmNN00x6IL3cvlzOlRUaw+Pj/BTttjcs+x6mbHCd0VuJPb+92SbRS
# wDSAnqeWcxTwPY50U3zaaw3SgH/ZWeXfRXC5KJ8Pd7Mq4+0wbpqodzGarlZc8Z+8
# AkaHruRrhYFD05+Cr23/h9gl67G3xaY2mrweqlLY8c+J6BqP4mR4vWq11YajIIZQ
# AG6XcWbVznjn//R5cOeiUz037bI9Wjj91JXf45BE4dqvukgTWcUwggbsMIIE1KAD
# AgECAhAwD2+s3WaYdHypRjaneC25MA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkx
# HjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRy
# dXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xOTA1MDIwMDAwMDBa
# Fw0zODAxMTgyMzU5NTlaMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
# IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28g
# TGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMgbAa/ZLH6ImX0BmD8gkL2c
# gCFUk7nPoD5T77NawHbWGgSlzkeDtevEzEk0y/NFZbn5p2QWJgn71TJSeS7JY8IT
# m7aGPwEFkmZvIavVcRB5h/RGKs3EWsnb111JTXJWD9zJ41OYOioe/M5YSdO/8zm7
# uaQjQqzQFcN/nqJc1zjxFrJw06PE37PFcqwuCnf8DZRSt/wflXMkPQEovA8NT7OR
# AY5unSd1VdEXOzQhe5cBlK9/gM/REQpXhMl/VuC9RpyCvpSdv7QgsGB+uE31DT/b
# 0OqFjIpWcdEtlEzIjDzTFKKcvSb/01Mgx2Bpm1gKVPQF5/0xrPnIhRfHuCkZpCkv
# RuPd25Ffnz82Pg4wZytGtzWvlr7aTGDMqLufDRTUGMQwmHSCIc9iVrUhcxIe/arK
# CFiHd6QV6xlV/9A5VC0m7kUaOm/N14Tw1/AoxU9kgwLU++Le8bwCKPRt2ieKBtKW
# h97oaw7wW33pdmmTIBxKlyx3GSuTlZicl57rjsF4VsZEJd8GEpoGLZ8DXv2DolNn
# yrH6jaFkyYiSWcuoRsDJ8qb/fVfbEnb6ikEk1Bv8cqUUotStQxykSYtBORQDHin6
# G6UirqXDTYLQjdprt9v3GEBXc/Bxo/tKfUU2wfeNgvq5yQ1TgH36tjlYMu9vGFCJ
# 10+dM70atZ2h3pVBeqeDAgMBAAGjggFaMIIBVjAfBgNVHSMEGDAWgBRTeb9aqitK
# z1SA4dibwJ3ysgNmyzAdBgNVHQ4EFgQUGqH4YRkgD8NBd0UojtE1XwYSBFUwDgYD
# VR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYB
# BQUHAwgwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6
# Ly9jcmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5LmNybDB2BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9j
# cnQudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggr
# BgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwF
# AAOCAgEAbVSBpTNdFuG1U4GRdd8DejILLSWEEbKw2yp9KgX1vDsn9FqguUlZkCls
# Ycu1UNviffmfAO9Aw63T4uRW+VhBz/FC5RB9/7B0H4/GXAn5M17qoBwmWFzztBEP
# 1dXD4rzVWHi/SHbhRGdtj7BDEA+N5Pk4Yr8TAcWFo0zFzLJTMJWk1vSWVgi4zVx/
# AZa+clJqO0I3fBZ4OZOTlJux3LJtQW1nzclvkD1/RXLBGyPWwlWEZuSzxWYG9vPW
# S16toytCiiGS/qhvWiVwYoFzY16gu9jc10rTPa+DBjgSHSSHLeT8AtY+dwS8BDa1
# 53fLnC6NIxi5o8JHHfBd1qFzVwVomqfJN2Udvuq82EKDQwWli6YJ/9GhlKZOqj0J
# 9QVst9JkWtgqIsJLnfE5XkzeSD2bNJaaCV+O/fexUpHOP4n2HKG1qXUfcb9bQ11l
# PVCBbqvw0NP8srMftpmWJvQ8eYtcZMzN7iea5aDADHKHwW5NWtMe6vBE5jJvHOsX
# TpTDeGUgOw9Bqh/poUGd/rG4oGUqNODeqPk85sEwu8CgYyz8XBYAqNDEf+oRnR4G
# xqZtMl20OAkrSQeq/eww2vGnL8+3/frQo4TZJ577AWZ3uVYQ4SBuxq6x+ba6yDVd
# M3aO8XwgDCp3rrWiAoa6Ke60WgCxjKvj+QrJVF3UuWp0nr1Irpgwggb2MIIE3qAD
# AgECAhEAkDl/mtJKOhPyvZFfCDipQzANBgkqhkiG9w0BAQwFADB9MQswCQYDVQQG
# EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
# b3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28g
# UlNBIFRpbWUgU3RhbXBpbmcgQ0EwHhcNMjIwNTExMDAwMDAwWhcNMzMwODEwMjM1
# OTU5WjBqMQswCQYDVQQGEwJHQjETMBEGA1UECBMKTWFuY2hlc3RlcjEYMBYGA1UE
# ChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDDCNTZWN0aWdvIFJTQSBUaW1lIFN0
# YW1waW5nIFNpZ25lciAjMzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AJCycT954dS5ihfMw5fCkJRy7Vo6bwFDf3NaKJ8kfKA1QAb6lK8KoYO2E+RLFQZe
# aoogNHF7uyWtP1sKpB8vbH0uYVHQjFk3PqZd8R5dgLbYH2DjzRJqiB/G/hjLk0NW
# esfOA9YAZChWIrFLGdLwlslEHzldnLCW7VpJjX5y5ENrf8mgP2xKrdUAT70KuIPF
# vZgsB3YBcEXew/BCaer/JswDRB8WKOFqdLacRfq2Os6U0R+9jGWq/fzDPOgNnDhm
# 1fx9HptZjJFaQldVUBYNS3Ry7qAqMfwmAjT5ZBtZ/eM61Oi4QSl0AT8N4BN3KxE8
# +z3N0Ofhl1tV9yoDbdXNYtrOnB786nB95n1LaM5aKWHToFwls6UnaKNY/fUta8pf
# ZMdrKAzarHhB3pLvD8Xsq98tbxpUUWwzs41ZYOff6Bcio3lBYs/8e/OS2q7gPE8P
# Wsxu3x+8Iq+3OBCaNKcL//4dXqTz7hY4Kz+sdpRBnWQd+oD9AOH++DrUw167aU1y
# meXxMi1R+mGtTeomjm38qUiYPvJGDWmxt270BdtBBcYYwFDk+K3+rGNhR5G8RrVG
# U2zF9OGGJ5OEOWx14B0MelmLLsv0ZCxCR/RUWIU35cdpp9Ili5a/xq3gvbE39x/f
# Qnuq6xzp6z1a3fjSkNVJmjodgxpXfxwBws4cfcz7lhXFAgMBAAGjggGCMIIBfjAf
# BgNVHSMEGDAWgBQaofhhGSAPw0F3RSiO0TVfBhIEVTAdBgNVHQ4EFgQUJS5oPGua
# KyQUqR+i3yY6zxSm8eAwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAwFgYD
# VR0lAQH/BAwwCgYIKwYBBQUHAwgwSgYDVR0gBEMwQTA1BgwrBgEEAbIxAQIBAwgw
# JTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdvLmNvbS9DUFMwCAYGZ4EMAQQC
# MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
# b1JTQVRpbWVTdGFtcGluZ0NBLmNybDB0BggrBgEFBQcBAQRoMGYwPwYIKwYBBQUH
# MAKGM2h0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1JTQVRpbWVTdGFtcGlu
# Z0NBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJ
# KoZIhvcNAQEMBQADggIBAHPa7Whyy8K5QKExu7QDoy0UeyTntFsVfajp/a3Rkg18
# PTagadnzmjDarGnWdFckP34PPNn1w3klbCbojWiTzvF3iTl/qAQF2jTDFOqfCFSr
# /8R+lmwr05TrtGzgRU0ssvc7O1q1wfvXiXVtmHJy9vcHKPPTstDrGb4VLHjvzUWg
# AOT4BHa7V8WQvndUkHSeC09NxKoTj5evATUry5sReOny+YkEPE7jghJi67REDHVB
# wg80uIidyCLxE2rbGC9ueK3EBbTohAiTB/l9g/5omDTkd+WxzoyUbNsDbSgFR36b
# LvBk+9ukAzEQfBr7PBmA0QtwuVVfR745ZM632iNUMuNGsjLY0imGyRVdgJWvAvu0
# 0S6dOHw14A8c7RtHSJwialWC2fK6CGUD5fEp80iKCQFMpnnyorYamZTrlyjhvn0b
# oXztVoCm9CIzkOSEU/wq+sCnl6jqtY16zuTgS6Ezqwt2oNVpFreOZr9f+h/EqH+n
# oUgUkQ2C/L1Nme3J5mw2/ndDmbhpLXxhL+2jsEn+W75pJJH/k/xXaZJL2QU/bYZy
# 06LQwGTSOkLBGgP70O2aIbg/r6ayUVTVTMXKHxKNV8Y57Vz/7J8mdq1kZmfoqjDg
# 0q23fbFqQSduA4qjdOCKCYJuv+P2t7yeCykYaIGhnD9uFllLFAkJmuauv2AV3Yb1
# MYIGDzCCBgsCAQEwgYwweDELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMRAw
# DgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE0MDIGA1UEAwwrU1NM
# LmNvbSBDb2RlIFNpZ25pbmcgSW50ZXJtZWRpYXRlIENBIFJTQSBSMQIQeVwkxuz4
# snsBAPX7/vbayDANBglghkgBZQMEAgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKAC
# gAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsx
# DjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCDfLOq/MdmtVpXz/GeOFdBw
# ehKUnwILdhrLo8LFuRYG9zANBgkqhkiG9w0BAQEFAASCAYB6WDHKqs3qwtGzZwgx
# Os2h6PSlEzHtcj9AYg11+MhPQY/O3uvVz3CHo5SwdbyvEbCvY26VcUhI1htd7zd+
# XYkZVIuASoiNtDnZ/53qvFxeoZDZA1+GtFBtFR26qhmOy0W29hZldsPVYVivo2b+
# GGJE25058pprWfa0z148bC7BVy34XEnNBjmovSBhu3KL6yYx+DeOjS2XnSFcKjtY
# xuxhtT707VJe5z8HghAYYT1DprWerHGlYZYzozmQZ1fsqEz5eU59WrwECIYLYM9p
# cOtpXhaMo0SXpLKo1grCXim1xrDaK2by7xii5O4p811U/5K729+xk4DW2+TVK/mr
# s26iTm86hlySx5+O/7nyLaAbpN998PtOV1Q7uR4xmi6xfvpk8+ZYiNUKQAcQ53p/
# Hi/rZWcfKFEVOORLVjL6ZnUC5LyLtv1SlSXIWNcUgNQeGV9WyhC2Y5xFHqtkprn5
# 4RoYRsqUAA6cPw7bWGwhuc7MvLfsKDkMbiO6XsKdGAeyEvahggNMMIIDSAYJKoZI
# hvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdy
# ZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2Vj
# dGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5n
# IENBAhEAkDl/mtJKOhPyvZFfCDipQzANBglghkgBZQMEAgIFAKB5MBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIyMTIxNDAyMVow
# PwYJKoZIhvcNAQkEMTIEMIOC3jzPc6PjA/HgwrmtyvBwfgmfMJXDqBsMLagFpd52
# 1VF0wIsXkZLkmlMTGgY0uTANBgkqhkiG9w0BAQEFAASCAgBIWDbc76EVnUgXFSbL
# 0/2B/wDgaHz9okYMrIIFJlHTDmrIEWoYxOIDELWZbduR27p9sSkkGsSs1Ooc7ETF
# OOefUNWF2Ai+rNqtKjZIc9oxsFiWb9U6KyPijBieLuhuVK9zpvJRXg8NWueEBM03
# FPhy5sngerBShKBnAdWD91eda143f7S7jnRR4UBPSq80rM4qPxwEUkyoWwnxishp
# 56cSlzhiOb1+WgukzX736ANFlWeSxZWkygoQ4iEs5MV1vLeVN21Z+Sg7wEiUH0IU
# njimuxTYjL81qmwFMTlVNZztM408viBvoH2Ok2mtcNfMdlk9r1BHCZ4FBFggX0aG
# gLzDVctHrf0cBSH2EdChCdhLqTcKTzcIe9uX8l4RHL5x1C0EzzQdF+QmIEiOy7Zb
# fnmiZGXgCPPQFbaR6TW0GJIRHTzygDC2YDcG39XlcwrjpcYX8Brmcp39p2v0qAE/
# cZObFNoRKAfUlXMDJ3siC0NV+73LFjLRTMKCR0q6Gv87dS11Vh4eW8n85zbrq943
# sZAniVwDItA8zxeWY6Wt1/pzhy+Sjq+x92G8vpbt2BhyWyLHh4rOq+/465QS73e7
# jq9sdRubdYqF/5nDUcVz5dJezFGPnSnqdffvliTBvZ2CBKKXkBPNxF2vFIQTdZmc
# 3DjpvwYivAsykCeRJmprIvmDmw==
# SIG # End signature block
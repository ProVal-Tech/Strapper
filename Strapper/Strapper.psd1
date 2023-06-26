@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Strapper.psm1'

    # Version number of this module.
    ModuleVersion = '1.5.3'

    # ID used to uniquely identify this module
    GUID = '6fe5cf06-7b4f-4695-b022-1ca2feb0341f'

    # Author of this module
    Author = 'Stephen Nix'

    # Company or vendor of this module
    CompanyName = 'ProVal Tech'

    # Copyright statement for this module
    Copyright = '(c) ProVal Tech. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'A cross-platform helper module for PowerShell.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.0'

    RequiredAssemblies = @(
        './Libraries/SQLite/System.Data.SQLite.dll'
    )
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Copy-RegistryItem',
        'Get-StrapperLog',
        'Get-StoredObject',
        'Get-UserRegistryKeyProperty',
        'Install-Chocolatey',
        'Install-GitHubModule',
        'Publish-GitHubModule',
        'Remove-UserRegistryKeyProperty',
        'Set-RegistryKeyProperty',
        'Set-StrapperEnvironment',
        'Set-UserRegistryKeyProperty',
        'Write-Log',
        'Write-StoredObject',
        'Get-WebFile',
        'Invoke-Script'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/ProVal-Tech/Strapper/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/ProVal-Tech/Strapper'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/ProVal-Tech/Strapper/main/res/img/strapper.png'

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/ProVal-Tech/Strapper/issues'
}

# SIG # Begin signature block
# MIInbQYJKoZIhvcNAQcCoIInXjCCJ1oCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDGLcLjdEm7VcFj
# N+w6FYDXxyC3Ggk94nGY2Yf8YSBJOKCCILUwggXYMIIEwKADAgECAhEA5CcElfaM
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
# M3aO8XwgDCp3rrWiAoa6Ke60WgCxjKvj+QrJVF3UuWp0nr1Irpgwggb1MIIE3aAD
# AgECAhA5TCXhfKBtJ6hl4jvZHSLUMA0GCSqGSIb3DQEBDAUAMH0xCzAJBgNVBAYT
# AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZv
# cmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBS
# U0EgVGltZSBTdGFtcGluZyBDQTAeFw0yMzA1MDMwMDAwMDBaFw0zNDA4MDIyMzU5
# NTlaMGoxCzAJBgNVBAYTAkdCMRMwEQYDVQQIEwpNYW5jaGVzdGVyMRgwFgYDVQQK
# Ew9TZWN0aWdvIExpbWl0ZWQxLDAqBgNVBAMMI1NlY3RpZ28gUlNBIFRpbWUgU3Rh
# bXBpbmcgU2lnbmVyICM0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# pJMoUkvPJ4d2pCkcmTjA5w7U0RzsaMsBZOSKzXewcWWCvJ/8i7u7lZj7JRGOWogJ
# ZhEUWLK6Ilvm9jLxXS3AeqIO4OBWZO2h5YEgciBkQWzHwwj6831d7yGawn7XLMO6
# EZge/NMgCEKzX79/iFgyqzCz2Ix6lkoZE1ys/Oer6RwWLrCwOJVKz4VQq2cDJaG7
# OOkPb6lampEoEzW5H/M94STIa7GZ6A3vu03lPYxUA5HQ/C3PVTM4egkcB9Ei4GOG
# p7790oNzEhSbmkwJRr00vOFLUHty4Fv9GbsfPGoZe267LUQqvjxMzKyKBJPGV4ag
# czYrgZf6G5t+iIfYUnmJ/m53N9e7UJ/6GCVPE/JefKmxIFopq6NCh3fg9EwCSN1Y
# pVOmo6DtGZZlFSnF7TMwJeaWg4Ga9mBmkFgHgM1Cdaz7tJHQxd0BQGq2qBDu9o16
# t551r9OlSxihDJ9XsF4lR5F0zXUS0Zxv5F4Nm+x1Ju7+0/WSL1KF6NpEUSqizADK
# h2ZDoxsA76K1lp1irScL8htKycOUQjeIIISoh67DuiNye/hU7/hrJ7CF9adDhdgr
# OXTbWncC0aT69c2cPcwfrlHQe2zYHS0RQlNxdMLlNaotUhLZJc/w09CRQxLXMn2Y
# bON3Qcj/HyRU726txj5Ve/Fchzpk8WBLBU/vuS/sCRMCAwEAAaOCAYIwggF+MB8G
# A1UdIwQYMBaAFBqh+GEZIA/DQXdFKI7RNV8GEgRVMB0GA1UdDgQWBBQDDzHIkSqT
# vWPz0V1NpDQP0pUBGDAOBgNVHQ8BAf8EBAMCBsAwDAYDVR0TAQH/BAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBKBgNVHSAEQzBBMDUGDCsGAQQBsjEBAgEDCDAl
# MCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3RpZ28uY29tL0NQUzAIBgZngQwBBAIw
# RAYDVR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdv
# UlNBVGltZVN0YW1waW5nQ0EuY3JsMHQGCCsGAQUFBwEBBGgwZjA/BggrBgEFBQcw
# AoYzaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBVGltZVN0YW1waW5n
# Q0EuY3J0MCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkq
# hkiG9w0BAQwFAAOCAgEATJtlWPrgec/vFcMybd4zket3WOLrvctKPHXefpRtwyLH
# BJXfZWlhEwz2DJ71iSBewYfHAyTKx6XwJt/4+DFlDeDrbVFXpoyEUghGHCrC3vLa
# ikXzvvf2LsR+7fjtaL96VkjpYeWaOXe8vrqRZIh1/12FFjQn0inL/+0t2v++kwzs
# baINzMPxbr0hkRojAFKtl9RieCqEeajXPawhj3DDJHk6l/ENo6NbU9irALpY+zWA
# T18ocWwZXsKDcpCu4MbY8pn76rSSZXwHfDVEHa1YGGti+95sxAqpbNMhRnDcL411
# TCPCQdB6ljvDS93NkiZ0dlw3oJoknk5fTtOPD+UTT1lEZUtDZM9I+GdnuU2/zA2x
# OjDQoT1IrXpl5Ozf4AHwsypKOazBpPmpfTXQMkCgsRkqGCGyyH0FcRpLJzaq4Jgc
# g3Xnx35LhEPNQ/uQl3YqEqxAwXBbmQpA+oBtlGF7yG65yGdnJFxQjQEg3gf3AdT4
# LhHNnYPl+MolHEQ9J+WwhkcqCxuEdn17aE+Nt/cTtO2gLe5zD9kQup2ZLHzXdR+P
# EMSU5n4k5ZVKiIwn1oVmHfmuZHaR6Ej+yFUK7SnDH944psAU+zI9+KmDYjbIw74A
# hxyr+kpCHIkD3PVcfHDZXXhO7p9eIOYJanwrCKNI9RX8BE/fzSEceuX1jhrUuUAx
# ggYOMIIGCgIBATCBjDB4MQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAO
# BgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBDb3JwMTQwMgYDVQQDDCtTU0wu
# Y29tIENvZGUgU2lnbmluZyBJbnRlcm1lZGlhdGUgQ0EgUlNBIFIxAhB5XCTG7Piy
# ewEA9fv+9trIMA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKA
# AKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIFwmMpagytJjzbXPoKISgbRy
# fKQBGgEJE8QTPiHrbBJ1MA0GCSqGSIb3DQEBAQUABIIBgLtMn+TJh1+2w/ybdc67
# VVrDux/upL1hxwwdL+Qqg1ACJA0mMm91aNrXuDjXVhCLNYMOzDUIlqDUlfoM2HFf
# HFFZO/qqTTa8uhX9jCwSoSyDJab8uI2TrSSfjrGfFXgo8hDNkoCcykR3hpnjES8q
# izQm18syyRH1r5X5FNvYHI1Xeh8c/Ui41lxfJ9LGwMM9mXHcWu2aJtnA9P+DjTaa
# HuzKM7mdXpmZKpgzhu1+1PtUxR0s4nJZFZeFJTrEsx6qKUcN7L2KkzNxGLvgj3oU
# e3PLxh9VYs7Cn6OwR3TzCQ+L2mi/FgFNUGBS8xtEmv8JBgk1EintfgKWTfnv8+A+
# 7dcZa8bORaDYf1f9xKfdcI+oK4PT0Q7Ku6mBVrzuOFV15NQS0UVwnyHMRgS1c1CW
# gTiN3oChKkvjlHoVHjxdl1wgnQ+rEVFpg20sQb36oTWeoEL0w2K5GWR5AK4aiWpt
# 7rczSAXSqRaYDDtyv5PBdNPRX6/I8MunYGxl17MnELbE6KGCA0swggNHBgkqhkiG
# 9w0BCQYxggM4MIIDNAIBATCBkTB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
# YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0
# aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcg
# Q0ECEDlMJeF8oG0nqGXiO9kdItQwDQYJYIZIAWUDBAICBQCgeTAYBgkqhkiG9w0B
# CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMzA2MjYxODUxMzBaMD8G
# CSqGSIb3DQEJBDEyBDDZHK2cyQ1VB3uw2+nKztJGi5HgrSqRyB+sDBISLSy1SR7I
# /LOJ2jAKq5Wt4o63xhUwDQYJKoZIhvcNAQEBBQAEggIAHMnfMsBXClhwmkyEDymj
# 0wpcUN1YjXSV7cnq73p2IPoWsvKai4X5agRpGyHDY+QGOMCqyoRYtNWBfirXLhlO
# OilVagJcq8E/EBsqS96ITCbf8ikMBvV8zYImfn2y6EEsb8RvOPCEd6O+qsns4fqy
# afH0otxjrKqnECGHXgNcwJACV86OOu59cgQ5XG3P9Xg8cQ95WVlNU+s2fpSbSsEs
# M3yoQmGRBcD371W4t8GCE18POqqLaVM7HRT7/wdXgvs5reQcwWi7GerlhtL+KyyE
# nayA5eECiSeZxPu9FgfKStJEbQUYx+5nhOmEj0omHjPEA3JBrjBsPJdD1WZV3kvG
# ZWnH9AqHLDlgfOXDis2XxQ6Eyj6KgLhoFfKLZvwEUdZX/VxQmIeBBiqSGZmywVyN
# /Q72sJ4uApLcd/678KivSXmD4wBhZB0A17DzFDg92Xitmgz4R1gPavVA4/g5sVD1
# 9cHWbhkGCgW/98V82TPTVcGmo5sHE13Z+QmGdwCLFEVO03lwGXDkVlBlR8A+X3h8
# ViQ4YOn5QJizwihLIPapvVhkl5IWwm9BX36F5yXNyJDEfxQe9WIiGMMwvitABTn1
# k/h/TNeBcaBbUS/ykhmnH+//8Q34LiupmV9eY9broa8XDzcVWtiJdcEnle10859i
# vX97pY0OTPeaS0lCJrKYZuI=
# SIG # End signature block

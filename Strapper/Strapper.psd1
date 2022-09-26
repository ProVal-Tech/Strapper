@{

# Script module or binary module file associated with this manifest.
RootModule = 'Strapper.psm1'

# Version number of this module.
ModuleVersion = '1.1.0'

# Supported PSEditions
# CompatiblePSEditions = @()

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
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    ".\public\Install-GitHubModule.ps1",
    ".\public\Publish-GitHubModule.ps1",
    ".\public\Write-Log.ps1",
    ".\public\Get-StrapperWorkingPath.ps1",
    ".\public\Install-Chocolatey.ps1",
    ".\public\Copy-RegistryItem.ps1",
    ".\public\Get-UserRegistryKeyProperty.ps1",
    ".\public\Remove-UserRegistryKeyProperty.ps1",
    ".\public\Set-RegistryKeyProperty.ps1",
    ".\public\Set-UserRegistryKeyProperty.ps1"

    ".\private\Write-InformationExtended.ps1",
    ".\private\Write-LogHelper.ps1",
    ".\private\Get-RegistryHivePath.ps1"
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    "Install-GitHubModule",
    "Publish-GitHubModule",
    "Write-Log",
    "Install-Chocolatey",
    "Copy-RegistryItem",
    "Get-UserRegistryKeyProperty",
    "Remove-UserRegistryKeyProperty",
    "Set-RegistryKeyProperty",
    "Set-UserRegistryKeyProperty"
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

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

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


# SIG # Begin signature block
# MIInSgYJKoZIhvcNAQcCoIInOzCCJzcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUE+ucsoK00wR5DJtToX5VGDZk
# 9FWggiC2MIIF2DCCBMCgAwIBAgIRAOQnBJX2jJHW0Ox7SU6k3xwwDQYJKoZIhvcN
# AQELBQAwfjELMAkGA1UEBhMCUEwxIjAgBgNVBAoTGVVuaXpldG8gVGVjaG5vbG9n
# aWVzIFMuQS4xJzAlBgNVBAsTHkNlcnR1bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
# eTEiMCAGA1UEAxMZQ2VydHVtIFRydXN0ZWQgTmV0d29yayBDQTAeFw0xODA5MTEw
# OTI2NDdaFw0yMzA5MTEwOTI2NDdaMHwxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVU
# ZXhhczEQMA4GA1UEBwwHSG91c3RvbjEYMBYGA1UECgwPU1NMIENvcnBvcmF0aW9u
# MTEwLwYDVQQDDChTU0wuY29tIFJvb3QgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkg
# UlNBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA+Q/doyt9y9Aq/uxn
# habnLhu6d+Hj9a+k7PpKXZHEV0drGHdrdvL9k+Q9D8IWngtmw1aUnheDhc5W7/IW
# /QBi9SIJVOhlF05BueBPRpeqG8i4bmJeabFf2yoCfvxsyvNB2O3Q6Pw/YUjtsAMU
# HRAOSxngu07shmX/NvNeZwILnYZVYf16OO3+4hkAt2+hUGJ1dDyg+sglkrRueiLH
# +B6h47LdkTGrKx0E/6VKBDfphaQzK/3i1lU0fBmkSmjHsqjTt8qhk4jrwZe8jPkd
# 2SKEJHTHBD1qqSmTzOu4W+H+XyWqNFjIwSNUnRuYEcM4nH49hmylD0CGfAL0XAJP
# KMuucZ8POsgz/hElNer8usVgPdl8GNWyqdN1eANyIso6wx/vLOUuqfqeLLZRRv2v
# A9bqYGjqhRY2a4XpHsCz3cQk3IAqgUFtlD7I4MmBQQCeXr9/xQiYohgsQkCz+W84
# J0tOgPQ9gUfgiHzqHM61dVxRLhwrfxpyKOcAtdF0xtfkn60Hk7ZTNTX8N+TD9l0W
# viFz3pIK+KBjaryWkmo++LxlVZve9Q2JJgT8JRqmJWnLwm3KfOJZX5es6+8uyLzX
# G1k8K8zyGciTaydjGc/86Sb4ynGbf5P+NGeETpnr/LN4CTNwumamdu0bc+sapQ3E
# IhMglFYKTixsTrH9z5wJuqIz7YcCAwEAAaOCAVEwggFNMBIGA1UdEwEB/wQIMAYB
# Af8CAQIwHQYDVR0OBBYEFN0ECQei9Xp9UlMSkpXuOIAlDaZZMB8GA1UdIwQYMBaA
# FAh2zcsH/yT2xc3tu5C84oQ3RnX3MA4GA1UdDwEB/wQEAwIBBjA2BgNVHR8ELzAt
# MCugKaAnhiVodHRwOi8vc3NsY29tLmNybC5jZXJ0dW0ucGwvY3RuY2EuY3JsMHMG
# CCsGAQUFBwEBBGcwZTApBggrBgEFBQcwAYYdaHR0cDovL3NzbGNvbS5vY3NwLWNl
# cnR1bS5jb20wOAYIKwYBBQUHMAKGLGh0dHA6Ly9zc2xjb20ucmVwb3NpdG9yeS5j
# ZXJ0dW0ucGwvY3RuY2EuY2VyMDoGA1UdIAQzMDEwLwYEVR0gADAnMCUGCCsGAQUF
# BwIBFhlodHRwczovL3d3dy5jZXJ0dW0ucGwvQ1BTMA0GCSqGSIb3DQEBCwUAA4IB
# AQAflZojVO6FwvPUb7npBI9Gfyz3MsCnQ6wHAO3gqUUt/Rfh7QBAyK+YrPXAGa0b
# oJcwQGzsW/ujk06MiWIbfPA6X6dCz1jKdWWcIky/dnuYk5wVgzOxDtxROId8lZwS
# aZQeAHh0ftzABne6cC2HLNdoneO6ha1J849ktBUGg5LGl6RAk4ut8WeUtLlaZ1Q8
# qBvZBc/kpPmIEgAGiCWF1F7u85NX1oH4LK739VFIq7ZiOnnb7C7yPxRWOsjZy6Si
# TyWo0ZurLTAgUAcab/HxlB05g2PoH/1J0OgdRrJGgia9nJ3homhBSFFuevw1lvRU
# 0rwrROVH13eCpUqrX5czqyQRMIIGcjCCBFqgAwIBAgIIZDNR08c4nwgwDQYJKoZI
# hvcNAQELBQAwfDELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMRAwDgYDVQQH
# DAdIb3VzdG9uMRgwFgYDVQQKDA9TU0wgQ29ycG9yYXRpb24xMTAvBgNVBAMMKFNT
# TC5jb20gUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBSU0EwHhcNMTYwNjI0
# MjA0NDMwWhcNMzEwNjI0MjA0NDMwWjB4MQswCQYDVQQGEwJVUzEOMAwGA1UECAwF
# VGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBDb3JwMTQwMgYD
# VQQDDCtTU0wuY29tIENvZGUgU2lnbmluZyBJbnRlcm1lZGlhdGUgQ0EgUlNBIFIx
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAn4MTc6qwxm0hy9uLeod0
# 0HHcjpdymuS7iDS03YADxi9FpHSavx4PUOqebXjzn/pRJqk9ndGylFc++zmJG5Er
# Vu9ny+YL4w45jMY19Iw93SXpAawXQn1YFkDc+dUoRB2VZDBhOmTyl9dzTH17IwJt
# 83XrVT1vqi3Er750rF3+arb86lx56Q9DnLVSBQ/vPrGxj9BJrabjQhlUP/MvDqHL
# fP4T+SM52iUcuD4ASjpvMjA3ZB7HrnUH2FXSGMkOiryjXPB8CqeFgcIOr4+ZXNNg
# JbyDWmkcJRPNcvXrnICb3CxnxN3JCZjVc+vEIaPlMo4+L1KYxmA3ZIyyb0pUchjM
# J4f6zXWiYyFMtT1k/Summ1WvJkxgtLlc/qtDva3QE2ZQHwvSiab/14AG8cMRAjMz
# YRf3Vh+OLzto5xXxd1ZKKZ4D2sIrJmEyW6BW5UkpjTan9cdSolYDIC84eIC99gau
# QTTLlEW9m8eJGB8Luv+prmpAmRPd71DfAbryBNbQMd80OF5XW8g4HlbUrEim7f/5
# uME77cIkvkRgp3fN1T2YWbRD6qpgfc3C5S/x6/XUINWXNG5dBGsFEdLTkowJJ0Tt
# TzUxRn50GQVi7Inj6iNwmOTRL9SKExhGk2XlWHPTTD0neiI/w/ijVbf55oeC7EUe
# xW46fLFOuato95tj1ZFBvKkCAwEAAaOB+zCB+DAPBgNVHRMBAf8EBTADAQH/MB8G
# A1UdIwQYMBaAFN0ECQei9Xp9UlMSkpXuOIAlDaZZMDAGCCsGAQUFBwEBBCQwIjAg
# BggrBgEFBQcwAYYUaHR0cDovL29jc3BzLnNzbC5jb20wEQYDVR0gBAowCDAGBgRV
# HSAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMDsGA1UdHwQ0MDIwMKAuoCyGKmh0dHA6
# Ly9jcmxzLnNzbC5jb20vc3NsLmNvbS1yc2EtUm9vdENBLmNybDAdBgNVHQ4EFgQU
# VML+EJUAk81q9efA19myS7iPDOMwDgYDVR0PAQH/BAQDAgGGMA0GCSqGSIb3DQEB
# CwUAA4ICAQD1DyaHcK+Zosr11snwjWY9OYLTiCPYgr+PVIQnttODB9eeJ4lNhI5U
# 0SDuYEPbV0I8x7CV9r7M6qM9jk8GxitZhn/rcxvK5UAm4D1vzPa9ccbNfQ4gQDnW
# BdKvlAi/f8JRtyu1e4Mh8GPa5ZzhaS51HU7LYR71pTPfAp0V2e1pk1e6RkUugLxl
# vucSPt5H/5CcEK32VrKk1PrW/C68lyGzdoPSkfoGUNGxgCiA/tutD2ft+H3c2XBb
# erpotbNKZheP5/DnV91p/rxe4dWMnxO7lZoV+3krhdVtPmdHbhsHXPtURQ8WES4R
# w7C8tW4cM1eUHv5CNEaOMVBO2zNXlfo45OYS26tYLkW32SLK9FpHSSwo6E+MQjxk
# aOnmQ6wZkanHE4Jf/HEKN7edUHs8XfeiUoI15LXn0wpva/6N+aTX1R1L531iCPjZ
# 16yZSdu1hEEULvYuYJdTS5r+8Yh6dLqedeng2qfJzCw7e0wKeM+U9zZgtoM8ilTL
# Tg1oKpQRdSYU6iA3zOt5F3ZVeHFt4kk4Mzfb5GxZxyNi5rzOLlRL/V4DKsjdHktx
# RNB1PjFiZYsppu0k4XodhDR/pBd8tKx9PzVYy8O/Gt2fVFZtReVT84iKKzGjyj5Q
# 0QA07CcIw2fGXOhov88uFmW4PGb/O7KVq5qNncyU8O14UH/sZEejnTCCBnYwggRe
# oAMCAQICEHlcJMbs+LJ7AQD1+/722sgwDQYJKoZIhvcNAQELBQAweDELMAkGA1UE
# BhMCVVMxDjAMBgNVBAgMBVRleGFzMRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQK
# DAhTU0wgQ29ycDE0MDIGA1UEAwwrU1NMLmNvbSBDb2RlIFNpZ25pbmcgSW50ZXJt
# ZWRpYXRlIENBIFJTQSBSMTAeFw0yMjA5MDgxODExMTZaFw0yMzA5MDcxODExMTZa
# MH8xCzAJBgNVBAYTAlVTMRAwDgYDVQQIDAdGbG9yaWRhMRowGAYDVQQHDBFBbHRh
# bW9udGUgU3ByaW5nczEgMB4GA1UECgwXUHJvdmFsIFRlY2hub2xvZ2llcyBJbmMx
# IDAeBgNVBAMMF1Byb3ZhbCBUZWNobm9sb2dpZXMgSW5jMIIBojANBgkqhkiG9w0B
# AQEFAAOCAY8AMIIBigKCAYEAvKxYE9H6zWDDro4T982ORi49oZ3YxNZuVIiFLVFy
# dDf1/lO2c6ZVxADqxIn6gKXQZU6wonKuBuasJPFFeqtIFOrQ8Yi/CFBzX+u9ejEy
# 2bk69PIHS1mOre+T4vCWM/RbYMojDQfJqNtjGPQ6Qa1vrjQhDu4WT/7Iqvq0YK6H
# sp/ApZiq5RLzVxyKa6pGhP4wYJlVmotzq8DHyuxu6NDDAQICKCM8hwVg+JweAZOu
# iGwMmOgtzkcAa6YM30+dfv8r9mhCm7mZZU0UcaYxaIagtNgWDa5bQJ8qUzu5VnU1
# sn5f2k8mPd5Lm1lSTK8OVe2kJG47WbiVDDt7mA5g3PG8N5EWH0/8oAOEWQRpMFja
# 8DlEdl4DhYyuN++I86WvyVuk2lP7/XrKSwe0S2KFMCjjT8jExBOXASTivdSMAXqH
# om9EkmGnb7QtlcYWlYgddopd5oDsT9eKP3JES+LC96IgAaqWLD4AStLaulnviVcl
# /vRhdhpI3txnOIzvtbPwd3DRAgMBAAGjggFzMIIBbzAMBgNVHRMBAf8EAjAAMB8G
# A1UdIwQYMBaAFFTC/hCVAJPNavXnwNfZsku4jwzjMFgGCCsGAQUFBwEBBEwwSjBI
# BggrBgEFBQcwAoY8aHR0cDovL2NlcnQuc3NsLmNvbS9TU0xjb20tU3ViQ0EtQ29k
# ZVNpZ25pbmctUlNBLTQwOTYtUjEuY2VyMFEGA1UdIARKMEgwCAYGZ4EMAQQBMDwG
# DCsGAQQBgqkwAQMDATAsMCoGCCsGAQUFBwIBFh5odHRwczovL3d3dy5zc2wuY29t
# L3JlcG9zaXRvcnkwEwYDVR0lBAwwCgYIKwYBBQUHAwMwTQYDVR0fBEYwRDBCoECg
# PoY8aHR0cDovL2NybHMuc3NsLmNvbS9TU0xjb20tU3ViQ0EtQ29kZVNpZ25pbmct
# UlNBLTQwOTYtUjEuY3JsMB0GA1UdDgQWBBTgGMwkPoaXHQprDWA3aheA76AuQzAO
# BgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAEh5tU/zuMAHplJ+WwH0
# Ep1s+K2jvVz0sFsrUKozGnUsgk6p8/7jt+/nXbGAZ5Wt9twG5f+81e904NnWA8uM
# jPVvTMS/Wd2spZ4HESO3M+AP9utp8tqUa42N2DUjXjNauHhgV7DG9m6ilRNXWfYP
# akpPi6SzqRMRKR+Jr2Y4461C9JEIZb8rUg1qSEImYCGCOyRVu01FwnTbY50S4aiC
# dPLH8oJOLXbjtdF0QuDacV3mRHqqFPBKVvCX6yER+c4P61lcoApbUhy5FWhpNI6V
# qy2Qg5qrhvQqIYTXQDxtjzIWXQJYo2n8noOWB87yueqplmbxnplW0Sv0zlwofFGT
# Stw4w0/KLspU3tWNKxujJfcl+6wR2jrt7HooieaP5ln7HvCkee50OfOJJC96gApv
# VldlplT0UClns4r/QrEM4pVSjLIQZUA6jWCAH6CGiHbkI0KF45jTdNMeiC93L5cz
# pUVGsPj4/wU7bY3LPsepmxwndFbiT2/vdkm0UsA0gJ6nlnMU8D2OdFN82msN0oB/
# 2Vnl30VwuSifD3ezKuPtMG6aqHcxmq5WXPGfvAJGh67ka4WBQ9Ofgq9t/4fYJeux
# t8WmNpq8HqpS2PHPiegaj+JkeL1qtdWGoyCGUABul3Fm1c545//0eXDnolM9N+2y
# PVo4/dSV3+OQROHar7pIE1nFMIIG7DCCBNSgAwIBAgIQMA9vrN1mmHR8qUY2p3gt
# uTANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBK
# ZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRS
# VVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlv
# biBBdXRob3JpdHkwHhcNMTkwNTAyMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjB9MQsw
# CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQH
# EwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNl
# Y3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgQ0EwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQDIGwGv2Sx+iJl9AZg/IJC9nIAhVJO5z6A+U++zWsB21hoEpc5H
# g7XrxMxJNMvzRWW5+adkFiYJ+9UyUnkuyWPCE5u2hj8BBZJmbyGr1XEQeYf0RirN
# xFrJ29ddSU1yVg/cyeNTmDoqHvzOWEnTv/M5u7mkI0Ks0BXDf56iXNc48RaycNOj
# xN+zxXKsLgp3/A2UUrf8H5VzJD0BKLwPDU+zkQGObp0ndVXRFzs0IXuXAZSvf4DP
# 0REKV4TJf1bgvUacgr6Unb+0ILBgfrhN9Q0/29DqhYyKVnHRLZRMyIw80xSinL0m
# /9NTIMdgaZtYClT0Bef9Maz5yIUXx7gpGaQpL0bj3duRX58/Nj4OMGcrRrc1r5a+
# 2kxgzKi7nw0U1BjEMJh0giHPYla1IXMSHv2qyghYh3ekFesZVf/QOVQtJu5FGjpv
# zdeE8NfwKMVPZIMC1Pvi3vG8Aij0bdonigbSlofe6GsO8Ft96XZpkyAcSpcsdxkr
# k5WYnJee647BeFbGRCXfBhKaBi2fA179g6JTZ8qx+o2hZMmIklnLqEbAyfKm/31X
# 2xJ2+opBJNQb/HKlFKLUrUMcpEmLQTkUAx4p+hulIq6lw02C0I3aa7fb9xhAV3Pw
# caP7Sn1FNsH3jYL6uckNU4B9+rY5WDLvbxhQiddPnTO9GrWdod6VQXqngwIDAQAB
# o4IBWjCCAVYwHwYDVR0jBBgwFoAUU3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0O
# BBYEFBqh+GEZIA/DQXdFKI7RNV8GEgRVMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMB
# Af8ECDAGAQH/AgEAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBEGA1UdIAQKMAgwBgYE
# VR0gADBQBgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20v
# VVNFUlRydXN0UlNBQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwdgYIKwYBBQUH
# AQEEajBoMD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVNF
# UlRydXN0UlNBQWRkVHJ1c3RDQS5jcnQwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3Nw
# LnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEMBQADggIBAG1UgaUzXRbhtVOBkXXf
# A3oyCy0lhBGysNsqfSoF9bw7J/RaoLlJWZApbGHLtVDb4n35nwDvQMOt0+LkVvlY
# Qc/xQuUQff+wdB+PxlwJ+TNe6qAcJlhc87QRD9XVw+K81Vh4v0h24URnbY+wQxAP
# jeT5OGK/EwHFhaNMxcyyUzCVpNb0llYIuM1cfwGWvnJSajtCN3wWeDmTk5Sbsdyy
# bUFtZ83Jb5A9f0VywRsj1sJVhGbks8VmBvbz1kteraMrQoohkv6ob1olcGKBc2Ne
# oLvY3NdK0z2vgwY4Eh0khy3k/ALWPncEvAQ2ted3y5wujSMYuaPCRx3wXdahc1cF
# aJqnyTdlHb7qvNhCg0MFpYumCf/RoZSmTqo9CfUFbLfSZFrYKiLCS53xOV5M3kg9
# mzSWmglfjv33sVKRzj+J9hyhtal1H3G/W0NdZT1QgW6r8NDT/LKzH7aZlib0PHmL
# XGTMze4nmuWgwAxyh8FuTVrTHurwROYybxzrF06Uw3hlIDsPQaof6aFBnf6xuKBl
# KjTg3qj5PObBMLvAoGMs/FwWAKjQxH/qEZ0eBsambTJdtDgJK0kHqv3sMNrxpy/P
# t/360KOE2See+wFmd7lWEOEgbsausfm2usg1XTN2jvF8IAwqd661ogKGuinutFoA
# sYyr4/kKyVRd1LlqdJ69SK6YMIIG9jCCBN6gAwIBAgIRAJA5f5rSSjoT8r2RXwg4
# qUMwDQYJKoZIhvcNAQEMBQAwfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0
# ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGln
# byBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5nIENB
# MB4XDTIyMDUxMTAwMDAwMFoXDTMzMDgxMDIzNTk1OVowajELMAkGA1UEBhMCR0Ix
# EzARBgNVBAgTCk1hbmNoZXN0ZXIxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEs
# MCoGA1UEAwwjU2VjdGlnbyBSU0EgVGltZSBTdGFtcGluZyBTaWduZXIgIzMwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCQsnE/eeHUuYoXzMOXwpCUcu1a
# Om8BQ39zWiifJHygNUAG+pSvCqGDthPkSxUGXmqKIDRxe7slrT9bCqQfL2x9LmFR
# 0IxZNz6mXfEeXYC22B9g480Saogfxv4Yy5NDVnrHzgPWAGQoViKxSxnS8JbJRB85
# XZywlu1aSY1+cuRDa3/JoD9sSq3VAE+9CriDxb2YLAd2AXBF3sPwQmnq/ybMA0Qf
# FijhanS2nEX6tjrOlNEfvYxlqv38wzzoDZw4ZtX8fR6bWYyRWkJXVVAWDUt0cu6g
# KjH8JgI0+WQbWf3jOtTouEEpdAE/DeATdysRPPs9zdDn4ZdbVfcqA23VzWLazpwe
# /OpwfeZ9S2jOWilh06BcJbOlJ2ijWP31LWvKX2THaygM2qx4Qd6S7w/F7KvfLW8a
# VFFsM7ONWWDn3+gXIqN5QWLP/Hvzktqu4DxPD1rMbt8fvCKvtzgQmjSnC//+HV6k
# 8+4WOCs/rHaUQZ1kHfqA/QDh/vg61MNeu2lNcpnl8TItUfphrU3qJo5t/KlImD7y
# Rg1psbdu9AXbQQXGGMBQ5Pit/qxjYUeRvEa1RlNsxfThhieThDlsdeAdDHpZiy7L
# 9GQsQkf0VFiFN+XHaafSJYuWv8at4L2xN/cf30J7qusc6es9Wt340pDVSZo6HYMa
# V38cAcLOHH3M+5YVxQIDAQABo4IBgjCCAX4wHwYDVR0jBBgwFoAUGqH4YRkgD8NB
# d0UojtE1XwYSBFUwHQYDVR0OBBYEFCUuaDxrmiskFKkfot8mOs8UpvHgMA4GA1Ud
# DwEB/wQEAwIGwDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MEoGA1UdIARDMEEwNQYMKwYBBAGyMQECAQMIMCUwIwYIKwYBBQUHAgEWF2h0dHBz
# Oi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAEEAjBEBgNVHR8EPTA7MDmgN6A1hjNo
# dHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29SU0FUaW1lU3RhbXBpbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnNlY3Rp
# Z28uY29tL1NlY3RpZ29SU0FUaW1lU3RhbXBpbmdDQS5jcnQwIwYIKwYBBQUHMAGG
# F2h0dHA6Ly9vY3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBDAUAA4ICAQBz2u1o
# csvCuUChMbu0A6MtFHsk57RbFX2o6f2t0ZINfD02oGnZ85ow2qxp1nRXJD9+DzzZ
# 9cN5JWwm6I1ok87xd4k5f6gEBdo0wxTqnwhUq//EfpZsK9OU67Rs4EVNLLL3Ozta
# tcH714l1bZhycvb3Byjz07LQ6xm+FSx4781FoADk+AR2u1fFkL53VJB0ngtPTcSq
# E4+XrwE1K8ubEXjp8vmJBDxO44ISYuu0RAx1QcIPNLiIncgi8RNq2xgvbnitxAW0
# 6IQIkwf5fYP+aJg05Hflsc6MlGzbA20oBUd+my7wZPvbpAMxEHwa+zwZgNELcLlV
# X0e+OWTOt9ojVDLjRrIy2NIphskVXYCVrwL7tNEunTh8NeAPHO0bR0icImpVgtny
# ughlA+XxKfNIigkBTKZ58qK2GpmU65co4b59G6F87VaApvQiM5DkhFP8KvrAp5eo
# 6rWNes7k4EuhM6sLdqDVaRa3jma/X/ofxKh/p6FIFJENgvy9TZntyeZsNv53Q5m4
# aS18YS/to7BJ/lu+aSSR/5P8V2mSS9kFP22GctOi0MBk0jpCwRoD+9DtmiG4P6+m
# slFU1UzFyh8SjVfGOe1c/+yfJnatZGZn6Kow4NKtt32xakEnbgOKo3TgigmCbr/j
# 9re8ngspGGiBoZw/bhZZSxQJCZrmrr9gFd2G9TGCBf4wggX6AgEBMIGMMHgxCzAJ
# BgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
# A1UECgwIU1NMIENvcnAxNDAyBgNVBAMMK1NTTC5jb20gQ29kZSBTaWduaW5nIElu
# dGVybWVkaWF0ZSBDQSBSU0EgUjECEHlcJMbs+LJ7AQD1+/722sgwCQYFKw4DAhoF
# AKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcN
# AQkEMRYEFGMIKF8658jLcXDvG9R1QVroYFqQMA0GCSqGSIb3DQEBAQUABIIBgCjx
# 8R4DupMXVWTDq+aJDm1e89gpugIcl4kMIxAz7w/vRkvNsGaWXoEnCya+vCaJungJ
# Nm2zdoquYb26BgV2wISfodhjsSiZVfusk4h7T3OtzqYSNozn8UpHKf91eQleGb7T
# XqP/gSavWSdDg5ECYZdK7kGDtO8RDbgtbqtWLWXHveDxAboszfGo/dp3Ah+r2ji+
# g8LcOGKYid9POImP+1XmfXmL5JVYmxflpMjtcApCjTKhvdRpV7Cvyg7/XRTHTPKg
# buAwZvRxfIbOqWrT02ggED7kgYhtBZ49boltkfX2m07gmLppQxQ+oHjd/r1VBdfI
# DrISE8tUHu4uxv9m3Qlg2p5PWBNL1kLLrS6i8PIcdMA+SqeJqmJ+B9GyIoOiYVfQ
# eVwY4D/2OkFyIJ/9Sfjyf9ehGRUKxqZM0Gl4MTGolfD6dr1OXc1QcoNjUJsU/twp
# v27r80zxtMgkaPrjYrovEv9+dXk9HBjUD7lpigflBsu8CFNzCELugV4RskRcsaGC
# A0wwggNIBgkqhkiG9w0BCQYxggM5MIIDNQIBATCBkjB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgw
# FgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRp
# bWUgU3RhbXBpbmcgQ0ECEQCQOX+a0ko6E/K9kV8IOKlDMA0GCWCGSAFlAwQCAgUA
# oHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIw
# OTI2MTgxODAzWjA/BgkqhkiG9w0BCQQxMgQwPCSpKkOpKNH7Z5chEa7yKTWOzuAk
# B0fW/WPoVfMi/lsbUZLForOEE4mfN+mw5rkbMA0GCSqGSIb3DQEBAQUABIICAEtk
# wG/hQI/9FsHI8tYPeCNlWvnTkqp+i3Tj1/1PNcDzX0BeN2fS01jIf9U9D/1iRi9W
# nLQeFzyL6ovM8dwXLZfvbz3tvk1GQEbuadJSFrvkV0ooj7Wp22yOUODpevRsN4Gf
# hFvinZSFmVrgbC9Ivt3HoE0u6hlhEOWLg0QdURsW4tcWYx0MupO5Y+zUFC6hFmkl
# LH7f5TNLbQ1q/oEVoeDS4k8Q544c2mOmpCzbUrhY07fNMk2sUyLfDSuh3WuN3f/z
# u7Yl2bIwnY7qWP76xr6QJMKFjC8QG8p5mDo3ShirvV20cnKxz8XvjqAs8VxQH/dH
# U9RHclO+tJGgoHJSz/lNLiG3S22RSmbVsfs98cDYNyxULbleaqaVqocapm5TrX3a
# ff0VS/YfycmZXo1ul8o9A7y1/iHw0pJpqNz7mvNRdw5WmzvMdhgZzLIx9KdQijhj
# 8jDQ8tKLO4PRqnGl5na0JXyAQ22qDsz22AQ9DZDtBk0Birbe15UDY42ZmSAMrlqN
# AMYHVohtfZAUp9QAHyscXSQEk061mAOeXXdM5kxyboG9ScQUTaEE1Rn8auWfRXJB
# SO9PqN6oAVbZY5N8d2OtTkqmqAOcUqBD+Lvg66Sj+YeKW088mzYs2SuoLG0A3HQ7
# 7kx46jkIu0JCyzaEKK5Sk5XU7vhFFeRS0Te4HCR1
# SIG # End signature block

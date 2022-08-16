function Install-Chocolatey {
    <#
    .SYNOPSIS
        Installs or updates the Chocolatey package manager.
    .EXAMPLE
        PS C:\> Install-Chocolatey
    #>
    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'Chocolatey is only supported on Windows-based platforms. Use your better package manager instead. ;)' -ErrorAction Stop
    }
    if ($env:path -split ';' -notcontains ";$($env:ALLUSERSPROFILE)\chocolatey\bin") {
        $env:Path = $env:Path + ";$($env:ALLUSERSPROFILE)\chocolatey\bin"
    }
    if (Test-Path -Path "$($env:ALLUSERSPROFILE)\chocolatey\bin") {
        Write-Log -Text 'Chocolatey installation detected.' -Type LOG
        choco upgrade chocolatey -y | Out-Null
        choco feature enable -n=allowGlobalConfirmation -confirm | Out-Null
        choco feature disable -n=showNonElevatedWarnings -confirm | Out-Null
        return 0
    } else {
        [Net.ServicePointManager]::SecurityProtocol = [Enum]::ToObject([Net.SecurityProtocolType], 3072)
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        choco feature enable -n=allowGlobalConfirmation -confirm | Out-Null
        choco feature disable -n=showNonElevatedWarnings -confirm | Out-Null
    }

    if (!(Test-Path -Path "$($env:ALLUSERSPROFILE)\chocolatey\bin")) {
        Write-Log -Text 'Chocolatey installation failed.' -Type ERROR
        return 1
    }
    return 0
}
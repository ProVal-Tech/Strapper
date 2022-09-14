<br />
<div align="center">
    <a href="https://github.com/ProVal-Tech/Strapper">
        <img src="res/img/strapper.png" alt="Logo" width="150" height="150">
    </a>
    <h3 align="center">Strapper</h3>
    <p align="center">
      A cross-platform helper module for PowerShell
    </p>
</div>

## About

Strapper is used as a general purpose toolbox for writing PowerShell scripts. It contains functions to assist with logging, registry management, installing other modules from GitHub, and more.

## Getting Started

Installing Strapper in PowerShell is easiest with [PowerShellGet v3](https://www.powershellgallery.com/packages/PowerShellGet/3.0.16-beta16) as it contains additional logic for installing modules from GitHub.

```powershell
# Install the prerelease version of PowerShellGet if not already at version 3+.
if (!(Get-Module -ListAvailable -Name PowerShellGet | Where-Object { $_.Version.Major -ge 3 })) {
    Install-Module -Name PowerShellGet -AllowPrerelease -Force
}

# Register the ProVal GitHub repo
Register-PSResourceRepository -Name ProValGitHub -URL 'https://nuget.pkg.github.com/ProVal-Tech/index.json'

# Install Strapper
Install-PSResource -Name "Strapper" -Repository ProValGitHub

# Optional: Remove the resource repository
Unregister-PSResourceRepository -Name ProValGitHub
```

### Alternative Install

```powershell
git clone "https://github.com/ProVal-Tech/Strapper" (Join-Path ($env:PSModulePath -split $(if(!$IsWindows) {':'} else {';'}) | Select-Object -First 1) "Strapper\1.0.0")
```

## Usage

Strapper is primarily intended for use inside of another script, but it will work perfectly well on the console. Check out the [public]("./public") folder for more information about the available functions.

```powershell
<# Invoke-StrapperTest.ps1 #>

# Import Strapper
Import-Module Strapper

# Writes to the log file Invoke-StrapperTest-log.txt
Write-Log -Message 'It works!'

# Writes to the log file Invoke-StrapperTest-log.txt and to the console.
Write-Log -Message 'It writes to the console!' -InformationAction 'Continue'
```

```powershell
<# Console run #>

# Import Strapper
Import-Module Strapper

# Writes to the log file yyyyMMdd-log.txt
Write-Log -Message 'It works!'

# Writes to the log file yyyyMMdd-log.txt and to the console.
Write-Log -Message 'It writes to the console!' -InformationAction 'Continue'
```

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

Strapper is used as a general-purpose toolbox for writing PowerShell scripts. It contains functions to assist with logging, registry management, installing other modules from GitHub, and more.

## Getting Started

Install from the PS Gallery

```powershell
Install-Module -Name Strapper -Force
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

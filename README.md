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

### Alternative Install (Requires [Module Builder](https://github.com/PoshCode/ModuleBuilder))

```powershell
git clone "https://github.com/ProVal-Tech/Strapper"
Push-Location -Path "./Strapper"
Remove-Item -Path ./Output -Recurse -Force -ErrorAction SilentlyContinue
$buildLocation = Build-Module -SourcePath ./Strapper -PassThru
Copy-Item -Path ./Strapper/Libraries -Destination $buildLocation.ModuleBase -Recurse
```

## Usage

Strapper is primarily intended for use inside of another script, but it will work perfectly well on the console. Check out the [Functions.md](./Functions.md) document for more information about the available functions.

```powershell
# Import Strapper
Import-Module Strapper

# Writes to the log file, the Information stream, and the Strapper database.
Write-Log -Message 'It works!' -Level Information
```

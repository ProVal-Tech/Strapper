# Strapper Functions

## Public Functions

### [Copy-RegistryItem](./docs/Copy-RegistryItem.md)
Copies a registry property or key to the target destination.

### [Get-StoredObject](./docs/Get-StoredObject.md)
Get previously stored objects from a Strapper object table.

### [Get-StrapperLog](./docs/Get-StrapperLog.md)
Get objects representing Strapper logs from a database.

### [Get-StrapperWorkingPath](./docs/Get-StrapperWorkingPath.md)
Returns the working path of the current script using Strapper.

### [Get-UserRegistryKeyProperty](./docs/Get-UserRegistryKeyProperty.md)
Gets a list of existing user registry properties.

### [Get-WebFile](./docs/Get-WebFile.md)
Downloads a file from a URI.

### [Install-Chocolatey](./docs/Install-Chocolatey.md)
Installs or updates the Chocolatey package manager.

### [Install-GitHubModule](./docs/Install-GitHubModule.md)
Install a PowerShell module from a GitHub repository via PowerShellGet v3.

### [Invoke-Script](./docs/Invoke-Script.md)
Run a PowerShell script from a local or remote path.

### [Publish-GitHubModule](./docs/Publish-GitHubModule.md)
Publish a PowerShell module to a GitHub repository.

### [Remove-UserRegistryKeyProperty](./docs/Remove-UserRegistryKeyProperty.md)
Removes a registry property value for existing user registry hives.

### [Set-RegistryKeyProperty](./docs/Set-RegistryKeyProperty.md)
Sets a Windows registry property value.

### [Set-StrapperEnviornment](./docs/Set-StrapperEnviornment.md)
Removes error and data files from the current working path and writes initialization information to the log.

### [Set-UserRegistryKeyProperty](./docs/Set-UserRegistryKeyProperty.md)
Creates or updates a registry property value for existing user registry hives.

### [Write-Log](./docs/Write-Log.md)
Writes text to a log file and the Information stream.

### [Write-StoredObject](./docs/Write-StoredObject.md)
Write one or more objects to a Strapper object table.

## Private Functions
### [Get-RegistryHivePath](./docs/Get-RegistryHivePath.md)
Gets a list of registry hives from the local computer.

### [Write-LogHelper](./docs/Write-LogHelper.md)
Helper function for [Write-Log](./docs/Write-Log.md).

### [Write-LogInformationExtended](./docs/Write-LogInformationExtended.md)
Helper function for [Write-LogHelper](./docs/Write-LogHelper.md) that allows for colorization of `Write-Information` output in the console.
#TODO: Make links to private functions
# Strapper Public Functions

Below is the list of all available functions that are used in Strapper and explanations of how to use them. You may also reference the comment-help section of any of the functions for documentation.

- [Copy-RegistryItem](#copy-registryitem)
- [Get-StrapperWorkingPath](#get-strapperworkingpath)
- [Get-UserRegistryKeyProperty](#get-userregistrykeyproperty)
- [Install-Chocolatey](#install-chocolatey)
- [Install-GitHubModule](#install-githubmodule)
- [Publish-GitHubModule](#publish-githubmodule)
- [Remove-UserRegistryKeyProperty](#remove-userregistrykeyproperty)
- [Set-RegistryKeyProperty](#set-registrykeyproperty)
- [Set-UserRegistryKeyProperty](#set-userregistrykeyproperty)

---

## Copy-RegistryItem
### Overview
Copies a registry property or key to the target destination.

### Requirements
- PowerShell v5
- Windows OS

### Usage
Copy all keys, subkeys, and properties from HKLM:\SOFTWARE\Canon to HKLM:\SOFTWARE\_automation\RegistryBackup

```powershell
Copy-RegistryItem -Path HKLM:\SOFTWARE\Canon -Destination HKLM:\SOFTWARE\_automation\RegistryBackup -Force -Recurse
```

Copy the PDFFormat property from HKLM:\SOFTWARE\Adobe to HKLM:\SOFTWARE\_automation\RegistryBackup\Adobe

```powershell
Copy-RegistryItem -Path HKLM:\SOFTWARE\Adobe -Name PDFFormat -Destination HKLM:\SOFTWARE\_automation\RegistryBackup\Adobe -Force
```

### Parameters
| Parameter     | Required | Default | Type   | Description                                            |
| ------------- | -------- | ------- | ------ | ------------------------------------------------------ |
| `Path`        | True     |         | String | The path to the key to copy.                           |
| `Destination` | True     |         | String | The path the the key to copy to.                       |
| `Name`        | False    |         | String | The name of the property to copy.                      |
| `Recurse`     | False    |         | Switch | Recursively copy all subkeys from the target key path. |
| `Force`       | False    |         | Switch | Create the destination key if it does not exist.       |

### Output
`Microsoft.Win32.RegistryKey`

[Back to Top](#strapper-public-functions)

---

## Get-StrapperWorkingPath
### Overview
Returns the working path of the current script using Strapper.

### Usage
```powershell
Get-ChildItem | Out-File -LiteralPath "$(Get-StrapperWorkingPath)\files.txt"
```

### Output
`System.String`

[Back to Top](#strapper-public-functions)

---

## Get-UserRegistryKeyProperty
### Overview
Gets a list of existing user registry properties.

### Requirements
- PowerShell v5
- Windows OS

### Usage
Gets the Prompter Timestamp property from each available user's registry hive.

```powershell
Get-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Prompter" -Name "Timestamp"
```

### Parameters
| Parameter | Required | Default     | Type   | Description                                        |
| --------- | -------- | ----------- | ------ | -------------------------------------------------- |
| `Path`    | True     |             | String | The relative registry path to the target property. |
| `Name`    | False    | '(Default)' | String | The name of the property to target.                |

### Output
`PSCustomObject`

[Back to Top](#strapper-public-functions)

---


## Install-Chocolatey
### Overview
Installs or updates the Chocolatey package manager.

### Requirements
- PowerShell v5
- Windows OS

### Usage
```powershell
Install-Chocolatey
```

### Output
Int32
1 = Failure
0 = Success

[Back to Top](#strapper-public-functions)

---

## Install-GitHubModule
### Overview
Install a PowerShell module from a GitHub repository via PowerShellGet v3.

This script requires a separate Azure function that returns a GitHub Personal Access Token based on two Base64 encoded scripts passed to it.

### Requirements
- PowerShell v5
- PowerShellGet v3 (will be installed if not present)
- Azure Function

### Usage
```powershell
Install-GitHubModule `
    -Name MyGithubModule `
    -Username GithubUser `
    -GitHubPackageUri 'https://nuget.pkg.github.com/GithubUser/index.json' `
    -AzureGithubPATUri 'https://pat-function-subdomain.azurewebsites.net/api/FunctionName' `
    -AzureGithubPATFunctionKey 'MyFunctionKey' `
    -CallingScriptPath 'C:\users\githubuser\scripts\MyCallingScript.ps1'
Import-Module -Name MyGithubModule
```

### Parameters
| Parameter                   | Required | Default | Type   | Description                                                      |
| --------------------------- | -------- | ------- | ------ | ---------------------------------------------------------------- |
| `Name`                      | True     |         | String | The name of the Github module to install.                        |
| `Username`                  | True     |         | String | The username of the Github user to authenticate with.            |
| `GithubPackageUri`          | True     |         | String | The URI to the Github Nuget package repository.                  |
| `AzureGithubPATUri`         | True     |         | String | The URI to the Azure function that will return the PAT.          |
| `AzureGithubPATFunctionKey` | True     |         | String | The function key for the Azure function.                         |
| `CallingScriptPath`         | True     |         | String | The path to the script that is attempting to install the module. |

### Output
No output.

[Back to Top](#strapper-public-functions)

---

## Publish-GitHubModule
### Overview
Publish a PowerShell module to a GitHub repository.

### Requirements
- PowerShell v5
- PowerShellGet v3 (will be installed if not found)

### Usage
```powershell
Publish-GitHubModule `
    -Path 'C:\users\user\Modules\MyModule\MyModule.psd1' `
    -Token 'ghp_abcdefg1234567' `
    -RepoUri 'https://github.com/user/MyModule'
```

### Parameters
| Parameter       | Required | Default                               | Type   | Description                                             |
| --------------- | -------- | ------------------------------------- | ------ | ------------------------------------------------------- |
| `Path`          | True     |                                       | String | The path to the psd1 file for the module to publish.    |
| `Token`         | True     |                                       | String | The Github personal access token to use for publishing. |
| `RepoUri`       | True     |                                       | String | The URI to the GitHub repo to publish to.               |
| `TempNugetPath` | False    | "$env:SystemDrive\temp\nuget\publish" | String | The path to use to make a temporary NuGet repo.         |

### Output
No output.

[Back to Top](#strapper-public-functions)

---

## Remove-UserRegistryKeyProperty
### Overview
Removes a registry property value for existing user registry hives.

### Requirements
- PowerShell v5

### Usage
Removes the `Timestamp` registry property from all user hives under the path `SOFTWARE\_automation\Test`

```powershell
Remove-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Test" -Name "Timestamp"
```
### Parameters
| Parameter | Required | Default | Type   | Description                                        |
| --------- | -------- | ------- | ------ | -------------------------------------------------- |
| `Path`    | True     |         | String | The relative registry path to the target property. |
| `Name`    | True     |         | String | The name of the property to target.                |

### Output
No output.

[Back to Top](#strapper-public-functions)

---

## Set-RegistryKeyProperty
### Overview
Sets a Windows registry property value.

### Requirements
- PowerShell v5

### Usage

Creates a DWord registry property with the name MyValueName and the value of 1. Will not create the key path if it does not exist.
```powershell
Set-RegistryKeyProperty -Path "HKLM:\SOFTWARE\_automation\Test\1\2\3\4" -Name "MyValueName" -Value "1" -Type DWord
```

Creates a String registry property based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.

```powershell
Set-RegistryKeyProperty -Path "HKLM:\SOFTWARE\_automation\Strings\New\Path" -Name "MyString" -Value "1234" -Force
```

### Parameters
| Parameter | Required | Default     | Type              | Description                                                                                                 |
| --------- | -------- | ----------- | ----------------- | ----------------------------------------------------------------------------------------------------------- |
| `Path`    | True     |             | String            | The registry path to the key to store the target property.                                                  |
| `Name`    | False    | '(Default)' | String            | The name of the property to create/update.                                                                  |
| `Value`   | True     |             | Object            | The value to set for the property.                                                                          |
| `Type`    | False    |             | RegistryValueKind | The type of value to set. If not passed, this will be inferred from the object type of the Value parameter. |
| `Force`   | False    |             | Switch            | Will create the registry key path to the property if it does not exist.                                     |
### Output
`PSCustomObject`

[Back to Top](#strapper-public-functions)

---

## Set-UserRegistryKeyProperty
### Overview
Creates or updates a registry property value for existing user registry hives.

### Requirements
- PowerShell v5

### Usage
Creates or updates a Dword registry property property for each available user's registry hive to a value of 1.

```powershell
Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Prompter" -Name "Timestamp" -Value 1
```

Creates or updates a String registry property based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.

```powershell
Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Strings\New\Path" -Name "MyString" -Value "1234" -Force
```

### Parameters
| Parameter        | Required | Default     | Type              | Description                                                                                                 |
| ---------------- | -------- | ----------- | ----------------- | ----------------------------------------------------------------------------------------------------------- |
| `Path`           | True     |             | String            | The registry path to the key to store the target property.                                                  |
| `Name`           | False    | '(Default)' | String            | The name of the property to create/update.                                                                  |
| `Value`          | True     |             | Object            | The value to set for the property.                                                                          |
| `Type`           | False    |             | RegistryValueKind | The type of value to set. If not passed, this will be inferred from the object type of the Value parameter. |
| `ExcludeDefault` | False    |             | Switch            | Exclude the Default user template from having the registry keys set.                                        |
| `Force`          | False    |             | Switch            | Will create the registry key path to the property if it does not exist.                                     |

### Output
`PSCustomObject[]`

[Back to Top](#strapper-public-functions)

---


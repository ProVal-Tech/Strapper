## Get-UserRegistryItem
### Overview
Retrieves a list of user-specific registry properties and their values.

### Requirements
- PowerShell v5
- Windows OS

### Usage
Retrieves all registry properties and their values for the specified path in each user's registry hive.

```powershell
Get-UserRegistryItem -Path "SOFTWARE\_automation\Prompter"
```

Retrieves all registry properties and their values for the specified path and its immediate subkeys from each user's registry hive.

```powershell
Get-UserRegistryItem -Path "SOFTWARE\_automation\Prompter" -ChildItem
```

Retrieves all registry properties and their values for the specified path and all its subkeys recursively from each user's registry hive.

```powershell
Get-UserRegistryItem -Path "SOFTWARE\_automation\Prompter" -Recurse
```

### Parameters
| Parameter   | Required | ParameterSet           | Type   | Description                                                                                        |
| ----------- | -------- | ---------------------- | ------ | -------------------------------------------------------------------------------------------------- |
| `Path`      | True     | `ChildItem`, `Recurse` | String | Specifies the relative registry path.                                                              |
| `ChildItem` | False    |     `ChildItem`        | Switch | Retrieves registry properties and their values for the specified path and its immediate subkeys.   |
| `Recurse`   | False    |     `Recurse`          | Switch | Retrieves registry properties and their values for the specified path and all subkeys recursively. |

### Output
`PSCustomObject`
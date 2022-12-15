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
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
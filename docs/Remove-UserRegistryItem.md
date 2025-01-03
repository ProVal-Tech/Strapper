## Remove-UserRegistryItem
### Overview
Deletes specific registry property values or keys for all existing user registry hives.

### Requirements
- PowerShell v5

### Usage
Removes all registry properties under "SOFTWARE\_automation\Prompter" for each user's registry hive.

```powershell
Remove-UserRegistryItem -Path "SOFTWARE\_automation\Prompter"
```

Removes all registry properties and subkeys under "SOFTWARE\_automation\Prompter" for each user's registry hive.

```powershell
Remove-UserRegistryItem -Path "SOFTWARE\_automation\Prompter" -Recurse
```
### Parameters
| Parameter | Required | Default | Type   | Description                                                                                                  |
| --------- | -------- | ------- | ------ | ------------------------------------------------------------------------------------------------------------ |
| `Path`    | True     |         | String | Specifies the relative registry path to the target properties or keys.                                       |
| `Recurse` | False    |         | Switch | When specified, removes all registry properties, keys, and associated subkeys for each user's registry hive. |

### Output
No output.
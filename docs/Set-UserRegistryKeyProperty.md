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
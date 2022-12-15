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
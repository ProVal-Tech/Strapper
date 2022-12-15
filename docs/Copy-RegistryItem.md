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
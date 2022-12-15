## Get-RegistryHivePath
### Overview
Gets a list of registry hives from the local computer.

### Requirements
- PowerShell v5
- Windows OS

### Usage
```powershell
Get-RegistryHivePath
```

### Output
`PSCustomObject`
```
SID                                                 UserHive                        Username
---                                                 --------                        --------
S-1-12-1-2222222222-2222222222-2222222222-222222222 C:\Users\user\ntuser.dat        user
DefaultUserTemplate                                 C:\Users\Default\ntuser.dat     DefaultUserTemplate
```
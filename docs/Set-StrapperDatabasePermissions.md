## Set-StrapperDatabasePermissions

### Overview

Grants modify permissions to the BUILTIN Users group for the Strapper module directory and any existing database files. This resolves SQLite journal file creation failures for non-admin users by ensuring the necessary directory and file access rights are in place.

### Requirements

- PowerShell v5
- Windows OS
- Administrator privileges (required to successfully modify permissions)

### Usage

```powershell
Set-StrapperDatabasePermissions
```

### Output

No output.
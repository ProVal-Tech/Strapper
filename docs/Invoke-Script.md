## Get-WebFile
### Overview
Run a PowerShell script from a local or remote path.

### Requirements
- PowerShell v5

### Usage
Runs the PowerShell script 'C:\Users\User\Restart-MyComputer.ps1'.

```powershell
Get-WebFile -Uri 'C:\Users\User\Restart-MyComputer.ps1'
```

Downloads and runs the PowerShell script 'Set-UserWallpaper.ps1', passing the given parameters to it.

```powershell
Get-WebFile -Uri 'https://file.contoso.com/scripts/Set-UserWallpaper.ps1' -Parameters @{
            User = 'Joe.Smith'
            Wallpaper = 'https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png'
        }
```

### Parameters
| Parameter    | Required | Default | Type       | Description                                                        |
| ------------ | -------- | ------- | ---------- | ------------------------------------------------------------------ |
| `Uri`        | True     |         | System.URI | The local path or URL of the target PowerShell script.             |
| `Parameters` | False    |         | hashtable  | A hashtable of parameters to pass to the target PowerShell script. |

### Output
This function will have varying output based on the called PowerShell script.
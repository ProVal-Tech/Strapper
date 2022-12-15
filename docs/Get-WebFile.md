## Get-WebFile
### Overview
Downloads a file from a URI.

### Requirements
- PowerShell v5

### Usage
Download a file to the specified path. Will not overwrite an existing file.

```powershell
Get-WebFile -Uri "https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png" -Path "C:\users\User\Miku.png"
```

Download a file to the specified path. Will overwrite an existing file.

```powershell
Get-WebFile -Uri "https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png" -Path "C:\users\User\Miku.png" -Clobber
```

Download a file to the specified path, returning the resulting `FileInfo` object. Will overwrite an existing file.

```powershell
Get-WebFile -Uri "https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png" -Path "C:\users\User\Miku.png" -PassThru -Clobber
```

### Parameters
| Parameter  | Required | Default | Type               | Description                                                     |
| ---------- | -------- | ------- | ------------------ | --------------------------------------------------------------- |
| `Uri`      | True     |         | System.URI         | The target URI to download from.                                |
| `Path`     | True     |         | System.IO.FileInfo | The full path to download the file to. (Must be a literal path) |
| `Clobber`  | False    |         | Switch             | Allow overwriting of an existing file.                          |
| `PassThru` | False    |         | Switch             | Return the `FileInfo` representation of the downloaded file.    |

### Output
None or `System.IO.FileInfo` if `-PassThru` is passed.
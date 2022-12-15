## Get-StrapperWorkingPath
### Overview
Returns the working path of the current script using Strapper.

### Usage
```powershell
Get-ChildItem | Out-File -LiteralPath "$(Get-StrapperWorkingPath)\files.txt"
```

### Output
`System.String`
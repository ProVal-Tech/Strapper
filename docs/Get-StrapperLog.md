## Get-StrapperLog
### Overview
Get objects representing Strapper logs from a database.

### Usage

Gets the Strapper logs from the `<scriptname>_logs` table with a minimum log level of 'Information'.
```powershell
Get-StrapperLog
```

Gets the Strapper logs from the `<scriptname>_logs` table with a minimum log level of 'Error'.
```powershell
Get-StrapperLog -MinimumLevel 'Error'
```

Gets the Strapper logs from the `<scriptname>_MyCustomLogTable` table with a minimum log level of 'Fatal'.
```powershell
Get-StrapperLog -MinimumLevel 'Fatal' -TableName 'MyCustomLogTable'
```

### Parameters
| Parameter      | Required | Default                     | Type   | Description                                                                |
| -------------- | -------- | --------------------------- | ------ | -------------------------------------------------------------------------- |
| `MinimumLevel` | False    | information                 | string | The minimum log level to gather from the table.                            |
| `TableName`    | False    | `$StrapperSession.LogTable` | string | The name of the table to retrieve logs from.                               |
| `DataSource`   | False    | `$StrapperSession.DBPath`   | string | The target SQLite datasource to use. Defaults to Strapper's `Strapper.db`. |

#### Log Levels
```
Highest --- Fatal
            Error
            Warning
            Information
            Debug
 Lowest --- Verbose
```

### Output
```
[System.Collections.Generic.List[StrapperLog]] - A list of logs from the table.
```
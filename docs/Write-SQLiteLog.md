## Write-SQLiteLog
### Overview
Writes a log entry to a Strapper log table.

### Usage

Logs a warning-level message to the default Strapper datasource and log table.
```powershell
Write-SQLiteLog -Message 'Logging a warning' -Level 'Warning'
```

Logs a fatal-level message to the default Strapper datasource under the 'myscript_error' table.
```powershell
Write-SQLiteLog -Message 'Logging a fatal error' -Level 'Fatal' -TableName 'myscript_error'
```

### Parameters
| Parameter    | Required | Default                     | Type             | Description                                                                      |
| ------------ | -------- | --------------------------- | ---------------- | -------------------------------------------------------------------------------- |
| `Message`    | True     |                             | string           | The message to write to the log table.                                           |
| `Level`      | True     |                             | StrapperLogLevel | The log level of the message.                                                    |
| `TableName`  | False    | `$StrapperSession.LogTable` | string           | The table to write the log message to. Must be a formatted Strapper log table.   |
| `DataSource` | False    | `$StrapperSession.DBPath`   | string           | The datasource to write the log message to. Defaults to the Strapper datasource. |
## Remove-SQLiteTable
### Overview
Removes a SQLite table from a target connection.

### Usage

Drops the table named 'myscript_data' if it exists.
```powershell
Remove-SQLiteTable -Name 'myscript_data' -Connection $Connection
```

### Parameters
| Parameter    | Required | Default | Type                                | Description                            |
| ------------ | -------- | ------- | ----------------------------------- | -------------------------------------- |
| `Name`       | True     |         | string                              | The name of the table to drop.         |
| `Connection` | True     |         | System.Data.SQLite.SQLiteConnection | The connection to drop the table from. |

### Output
```
[int] - Should always return -1 if the table was successfully dropped.
```
## Get-SQLiteTable
### Overview
Get table information from a SQLite connection.

### Usage
Returns information about all tables from the provided SQLite connection.
```powershell
Get-SQLiteTable -Connection $Connection
```

Returns information about the mydata table from the provided SQLite connection.
```powershell
Get-SQLiteTable -TableName mydata -Connection $Connection
```

### Parameters
| Parameter    | Required | Default | Type                                | Description                        |
| ------------ | -------- | ------- | ----------------------------------- | ---------------------------------- |
| `Name`       | False    |         | string                              | The name of the table to retrieve. |
| `Connection` | True     |         | System.Data.SQLite.SQLiteConnection | The SQLite connection to use.      |

### Output
```
[pscustomobject] - The table with the specified name.
[pscustomobject[]] - All tables from the target connection.
```
## New-SQLiteLogTable
### Overview
Creates a new SQLite table specifically designed for storing Strapper logs.

### Usage
Creates a new Strapper log table named 'myscript_logs' if it does not exist.
```powershell
New-SQLiteLogTable -Name 'myscript_logs' -Connection $Connection
```

Creates a new Strapper log table named 'myscript_logs', overwriting any existing table.
```powershell
New-SQLiteLogTable -Name 'myscript_logs' -Connection $Connection -Clobber
```

Creates a new Strapper log table named 'myscript_logs' if it does not exist and returns an object representing the created (or existing) table.
```powershell
New-SQLiteLogTable -Name 'myscript_logs' -Connection $Connection -PassThru
```

### Parameters
| Parameter    | Required | Default | Type                                | Description                                                    |
| ------------ | -------- | ------- | ----------------------------------- | -------------------------------------------------------------- |
| `Name`       | True     |         | string                              | The name of the table to create.                               |
| `Connection` | True     |         | System.Data.SQLite.SQLiteConnection | The connection to create the table with.                       |
| `Clobber`    | False    | False   | switch                              | Recreate the table (removing all existing data) if it exists.  |
| `PassThru`   | False    | False   | switch                              | Return an object representing the created (or existing) table. |

### Output
```
[pscustomobject] - An object representing the created (or existing) table. Will only return if -PassThru is used.
```
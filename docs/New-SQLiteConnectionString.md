## New-SQLiteConnectionString
### Overview
Get a new a SQLite connection string.

### Usage
Creates a new SQLite connection string from the default Datasource in Strapper.
```powershell
New-SQLiteConnectionString
```

Creates a new SQLite connection string with the datasource "C:\mySqlite.db".
```powershell
New-SQLiteConnectionString -Datasource "C:\mySqlite.db"
```

### Parameters
| Parameter    | Required | Default                   | Type   | Description                                      |
| ------------ | -------- | ------------------------- | ------ | ------------------------------------------------ |
| `Datasource` | False    | `$StrapperSession.DBPath` | string | The datasource to use for the connection string. |

### Output
```
[string] - The resulting SQLite connection string.
```
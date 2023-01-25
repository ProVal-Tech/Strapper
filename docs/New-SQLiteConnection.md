## New-SQLiteConnection
### Overview
Get a new a SQLite connection.

### Usage
Creates a new SQLite connection from the default Datasource in Strapper.
```powershell
New-SQLiteConnection
```

Creates a new SQLite connection to the datasource "C:\mySqlite.db" and opens the connection before returning.
```powershell
New-SQLiteConnection -Datasource "C:\mySqlite.db" -Open
```

### Parameters
| Parameter    | Required | Default                   | Type   | Description                                                 |
| ------------ | -------- | ------------------------- | ------ | ----------------------------------------------------------- |
| `Datasource` | False    | `$StrapperSession.DBPath` | string | The datasource to use for the connection.                   |
| `Open`       | False    | False                     | switch | Use this switch to open the connection before returning it. |

### Output
```
[System.Data.SQLite.SQLiteConnection] - The resulting SQLite connection object.
```
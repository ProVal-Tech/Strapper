## Get-StoredObject
### Overview
Get previously stored objects from a Strapper object table.

### Usage

Gets the stored objects list from the default `<scriptname>_data` table, including the object metadata.
```powershell
Get-StoredObject -IncludeMetadata
```

Gets the stored objects list from the `<scriptname>_disks` table.
```powershell
Get-StoredObject -TableName disks
```

### Parameters
| Parameter         | Required | Default                   | Type   | Description                                                                                                                    |
| ----------------- | -------- | ------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `TableName`       | False    | `<scriptname>_data`       | string | The name of the table to retrieve objects from.                                                                                |
| `DataSource`      | False    | `$StrapperSession.DBPath` | string | The target SQLite datasource to use. Defaults to Strapper's 'Strapper.db'.                                                     |
| `IncludeMetadata` | False    | False                     | switch | Include a Metadata property on each object that describes additional information about table name, insertion time, and row ID. |

### Output
```
[System.Collections.Generic.List[pscustomobject]] - A list of previously stored objects.
```
function Write-SQLiteObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter(Mandatory, ValueFromPipeline)][System.Object[]]$InputObject
    )
    begin {
        $objectList = [System.Collections.Generic.List[System.Object]]::new()
        [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
        New-SQLiteObjectTable -Name $TableName -Connection $sqliteConnection
        $sqliteCommand = $sqliteConnection.CreateCommand()
        $sqliteTransaction = $sqliteConnection.BeginTransaction()
        $sqliteCommand.Transaction = $sqliteTransaction
    }
    process {
        foreach($obj in $InputObject) {
            $sqliteCommand.CommandText = "INSERT INTO '$TableName' (json, timestamp) VALUES ()"
        }
    }
    end {
        [System.Collections.Generic.List[System.Data.DataRow]]$parsedDataRows = ($objectList | ConvertTo-ObjectDataRow)
        [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
        New-SQLiteObjectTable -Name $TableName -Connection $sqliteConnection
        $command = New-SQLiteCommand -Connection $sqliteConnection -CommandText "SELECT * FROM '$TableName'"
        $sqliteDataAdapter = [System.Data.SQLite.SQLiteDataAdapter]::new($command)
        $sqliteDataAdapter.MissingSchemaAction = [System.Data.MissingSchemaAction]::AddWithKey
        $existingDataSet = [System.Data.DataSet]::new()
        $sqliteDataAdapter.Fill($existingDataSet, $TableName) | Out-Null
        foreach($row in $parsedDataRows) {
            $existingDataSet.Tables[$TableName].ImportRow($row) | Out-Null
        }
        $sqliteDataAdapter.Update($existingDataSet, $TableName)
        $sqliteDataAdapter.Dispose()
        $sqliteConnection.Close()
    }
}
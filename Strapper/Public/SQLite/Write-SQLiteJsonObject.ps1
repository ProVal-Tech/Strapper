function Write-SQLiteJsonObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter(Mandatory, ValueFromPipeline)][System.Object[]]$InputObject,
        [Parameter()][int]$Depth = 64
    )
    begin {
        [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
        New-SQLiteObjectTable -Name $TableName -Connection $sqliteConnection
        $sqliteCommand = $sqliteConnection.CreateCommand()
        $sqliteTransaction = $sqliteConnection.BeginTransaction()
        $sqliteCommand.Transaction = $sqliteTransaction
    }
    process {
        foreach ($obj in $InputObject) {
            $jsonObjectString = $obj | ConvertTo-Json -Depth 64 -Compress
            $sqliteCommand.CommandText = "INSERT INTO '$TableName' (json, timestamp) VALUES (:json, (SELECT datetime('now')))"
            $sqliteCommand.Parameters.AddWithValue(':json', $jsonObjectString)
            $sqliteCommand.ExecuteNonQuery()
            $sqliteCommand.Parameters.Clear()
        }
    }
    end {
        $sqliteTransaction.Commit()
        $sqliteTransaction.Dispose()
        $sqliteConnection.Close()
        $sqliteConnection.Dispose()
    }
}
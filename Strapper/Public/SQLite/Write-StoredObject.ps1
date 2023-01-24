function Write-SQLiteObject {
    [CmdletBinding()]
    param(
        [Parameter()][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter(Mandatory, ValueFromPipeline)][System.Object[]]$InputObject,
        [Parameter()][int]$Depth = 64,
        [Parameter()][switch]$Clobber
    )
    begin {
        [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
        if(!$TableName) {
            $TableName = 'data'
        }
        $TableName = "$($StrapperSession.ScriptTitle)_$TableName"
        New-SQLiteObjectTable -Name $TableName -Connection $sqliteConnection -Clobber:$Clobber
        $sqliteCommand = $sqliteConnection.CreateCommand()
        $sqliteTransaction = $sqliteConnection.BeginTransaction()
        $sqliteCommand.Transaction = $sqliteTransaction
        $rowsAffected = 0
    }
    process {
        foreach ($obj in $InputObject) {
            $jsonObjectString = $obj | ConvertTo-Json -Depth $Depth -Compress
            $sqliteCommand.CommandText = "INSERT INTO '$TableName' (json, timestamp) VALUES (:json, (SELECT datetime('now')))"
            $sqliteCommand.Parameters.AddWithValue(':json', $jsonObjectString) | Out-Null
            $rowsAffected += $sqliteCommand.ExecuteNonQuery()
            $sqliteCommand.Parameters.Clear()
        }
    }
    end {
        $sqliteTransaction.Commit()
        Write-Verbose -Message "Rows affected: $rowsAffected"
        $sqliteTransaction.Dispose()
        $sqliteConnection.Dispose()
    }
}
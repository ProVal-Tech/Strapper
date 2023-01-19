function Get-StrapperLog {
    [CmdletBinding()]
    param (
        [Parameter()][StrapperLogLevel]$MaxLevel,
        [Parameter()][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName = $StrapperSession.LogTable,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath
    )
    [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
    if (!(Get-SQLiteTable -Name $TableName -Connection $sqliteConnection)) {
        Write-Warning -Message "No log table with the name '$TableName' was found in the database '$DataSource'"
    }
    #$sqliteCommand = $sqliteConnection.CreateCommand()
    # $sqliteCommand.CommandText = "INSERT INTO '$TableName' (level, message, timestamp) VALUES (:level, :message, (SELECT datetime('now')))"
    # $sqliteCommand.Parameters.AddWithValue(':level', $Level) | Out-Null
    # $sqliteCommand.Parameters.AddWithValue(':message', $Message) | Out-Null
    #$rowsAffected = $sqliteCommand.ExecuteNonQuery()
    $sqliteConnection.Dispose()
}
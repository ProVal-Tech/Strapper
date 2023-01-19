function Write-SQLiteLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Message,    
        [Parameter(Mandatory)][StrapperLogLevel]$Level,
        [Parameter()][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName = $StrapperSession.LogTable,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath
    )
    [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
    New-SQLiteLogTable -Name $TableName -Connection $sqliteConnection
    $sqliteCommand = $sqliteConnection.CreateCommand()
    $sqliteCommand.CommandText = "INSERT INTO '$TableName' (level, message, timestamp) VALUES (:level, :message, (SELECT datetime('now')))"
    $sqliteCommand.Parameters.AddWithValue(':level', $Level) | Out-Null
    $sqliteCommand.Parameters.AddWithValue(':message', $Message) | Out-Null
    $rowsAffected = $sqliteCommand.ExecuteNonQuery()
    $sqliteConnection.Dispose()
}
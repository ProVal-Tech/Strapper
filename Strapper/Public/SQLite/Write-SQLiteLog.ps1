function Write-SQLiteLog {
    <#
    .SYNOPSIS
        Writes a log entry to a Strapper log table.
    .EXAMPLE
        Write-SQLiteLog -Message 'Logging a warning' -Level 'Warning'
        Logs a warning-level message to the default Strapper datasource and log table.
    .EXAMPLE
        Write-SQLiteLog -Message 'Logging a fatal error' -Level 'Fatal' -TableName 'myscript_error'
        Logs a fatal-level message to the default Strapper datasource under the 'myscript_error' table.
    .PARAMETER Message
        The message to write to the log table.
    .PARAMETER Level
        The log level of the message.
    .PARAMETER TableName
        The table to write the log message to. Must be a formatted Strapper log table.
    .PARAMETER DataSource
        The datasource to write the log message to. Defaults to the Strapper datasource.
    #>
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
    $sqliteCommand.Parameters.AddWithValue(':level', $Level.value__) | Out-Null
    $sqliteCommand.Parameters.AddWithValue(':message', $Message) | Out-Null
    $rowsAffected = $sqliteCommand.ExecuteNonQuery()
    Write-Verbose -Message "Rows affected: $rowsAffected"
    $sqliteConnection.Dispose()
}


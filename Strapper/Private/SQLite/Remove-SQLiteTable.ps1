function Remove-SQLiteTable {
    [CmdletBinding()]
    [OutputType([int])]
    param (
        [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$Name,
        [Parameter(Mandatory)][System.Data.SQLite.SQLiteConnection]$Connection
    )
    $Connection.CreateCommand()
    $dropCommand = $Connection.CreateCommand()
    $dropCommand.CommandText = "DROP TABLE IF EXISTS '$Name';"
    $rowsAffected = $dropCommand.ExecuteNonQuery()
    Write-Verbose -Message "Affected row count: $rowsAffected"
    return $rowsAffected
}
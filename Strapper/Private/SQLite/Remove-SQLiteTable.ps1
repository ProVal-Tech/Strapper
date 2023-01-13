function Remove-SQLiteTable {
    [CmdletBinding()]
    [OutputType([int])]
    param (
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][System.Data.SQLite.SQLiteConnection]$Connection
    )
    $Connection.CreateCommand()
    $dropCommand = $Connection.CreateCommand()
    $dropCommand.CommandText = 'DROP TABLE IF EXISTS @tablename;'
    $dropCommand.Parameters.Add([System.Data.SQLite.SQLiteParameter]::new('tablename', $Name))
    $rowsAffected = $dropCommand.ExecuteNonQuery()
    Write-Verbose -Message "Affected row count: $rowsAffected"
    return $rowsAffected
}
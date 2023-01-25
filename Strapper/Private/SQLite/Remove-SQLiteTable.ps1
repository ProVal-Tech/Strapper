function Remove-SQLiteTable {
    <#
    .SYNOPSIS
        Removes a SQLite table from a target connection.
    .EXAMPLE
        Remove-SQLiteTable -Name 'myscript_data' -Connection $Connection
        Drops the table named 'myscript_data' if it exists.
    .PARAMETER Name
        The name of the table to drop.
    .PARAMETER Connection
        The connection to drop the table from.
    .OUTPUTS
        [int] - Should always return -1 if the table was successfully dropped.
    #>
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
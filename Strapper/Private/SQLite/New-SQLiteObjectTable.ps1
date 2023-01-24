function New-SQLiteObjectTable {
    <#
    .SYNOPSIS
        Creates a new SQLite table specifically designed for storing JSON representations of objects.
    .EXAMPLE
        New-SQLiteObjectTable -Name 'myscript_data' -Connection $Connection
        Creates a new JSON object table named 'myscript_data' if it does not exist.
    .EXAMPLE
        New-SQLiteObjectTable -Name 'myscript_logs' -Connection $Connection -Clobber
        Creates a new JSON object table named 'myscript_data', overwriting any existing table.
    .EXAMPLE
        New-SQLiteObjectTable -Name 'myscript_logs' -Connection $Connection -PassThru
        Creates a new JSON object table named 'myscript_data' if it does not exist and returns an object representing the created (or existing) table.
    .PARAMETER Name
        The name of the table to create.
    .PARAMETER Connection
        The connection to create the table with.
    .PARAMETER Clobber
        Recreate the table (removing all existing data) if it exists.
    .PARAMETER PassThru
        Return an object representing the created (or existing) table.
    .OUTPUTS
        [pscustomobject] - An object representing the created (or existing) table. Will only return if -PassThru is used.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$Name,
        [Parameter()][System.Data.SQLite.SQLiteConnection]$Connection,
        [Parameter()][switch]$Clobber,
        [Parameter()][switch]$PassThru
    )
    $targetTable = Get-SQLiteTable -Name $Name -Connection $Connection
    if ($targetTable -and !$Clobber) {
        Write-Verbose -Message "Target table '$Name' already exists. Pass -Clobber to overwrite this table."
    } else {
        Remove-SQLiteTable -Name $Name -Connection $Connection | Out-Null
        $createCommand = $Connection.CreateCommand()
        $createCommand.CommandText = @"
        CREATE TABLE "$Name" (
            "id"        INTEGER NOT NULL UNIQUE,
            "json"      JSON NOT NULL,
            "timestamp" DATETIME NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
        );
"@
        $rowsAffected = $createCommand.ExecuteNonQuery()
        Write-Verbose -Message "Affected row count: $rowsAffected"
        $targetTable = Get-SQLiteTable -Name $Name -Connection $Connection
        if (!$targetTable) {
            Write-Error -Exception ([System.Data.SQLite.SQLiteException]::new([System.Data.SQLite.SQLiteErrorCode]::IoErr, "Failed to create table '$Name'"))
            return
        }
    }
    if ($PassThru) {
        return $targetTable
    }
}
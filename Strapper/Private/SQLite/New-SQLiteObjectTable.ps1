function New-SQLiteObjectTable {
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
        if(!$targetTable) {
            Write-Error -Exception ([System.Data.SQLite.SQLiteException]::new([System.Data.SQLite.SQLiteErrorCode]::IoErr, "Failed to create table '$Name'"))
            return
        }
    }
    if ($PassThru) {
        return $targetTable
    }
}
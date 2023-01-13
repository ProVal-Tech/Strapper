function New-SQLiteObjectTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidatePattern("^[a-zA-Z0-9\-_]+$")][string]$Name,
        [Parameter()][System.Data.SQLite.SQLiteConnection]$Connection,
        [Parameter()][switch]$Clobber,
        [Parameter()][switch]$PassThru
    )
    $targetTable = Get-SQLiteTable -Name $Name
    if($targetTable -and !$Clobber) {
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
        $createCommand.Parameters.Add([System.Data.SQLite.SQLiteParameter]::new('tablename', $Name))
        
    }
    if($PassThru) {
        return $targetTable
    }
}
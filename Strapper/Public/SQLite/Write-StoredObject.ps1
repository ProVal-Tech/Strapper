function Write-StoredObject {
    <#
    .SYNOPSIS
        Write one or more objects to a Strapper object table.
    .EXAMPLE
        Get-Disk | Write-StoredObject
        Writes the output objects from Get-Disk to the default "<scriptname>_data" table.
    .EXAMPLE
        Get-Disk | Write-StoredObject -TableName disks
        Writes the output objects from Get-Disk to the "<scriptname>_disks" table.
    .PARAMETER TableName
        The name of the table to write objects to.
    .PARAMETER DataSource
        The target SQLite datasource to use. Defaults to Strapper's 'Strapper.db'.
    .PARAMETER InputObject
        The objects to write to the table.
    .PARAMETER Depth
        The depth that the JSON serializer will dive through an object's properties.
    .PARAMETER Clobber
        Recreate the table (removing all existing data) if it exists.
    #>
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
        if (!$TableName) {
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
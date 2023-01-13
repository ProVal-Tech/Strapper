function New-SQLiteCommand {
    [CmdletBinding()]
    [OutputType([System.Data.SQLite.SQLiteCommand])]
    param (
        [Parameter(Mandatory)][System.Data.SQLite.SQLiteConnection]$Connection,    
        [Parameter(Mandatory)][string]$CommandText,
        [Parameter()][hashtable]$Parameters
    )
    $sqliteCommand = $Connection.CreateCommand()
    $sqliteCommand.CommandText = $CommandText
    $sqliteParameters = $(foreach($key in $Parameters.Keys) {
        [System.Data.SQLite.SQLiteParameter]::new($key, $Parameters.$key)
    })
    $sqliteCommand.Parameters.AddRange($sqliteParameters)
    return $sqliteCommand
}
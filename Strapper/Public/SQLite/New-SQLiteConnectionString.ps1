function New-SQLiteConnectionString {
    <#
    .SYNOPSIS
        Get a new a SQLite connection string.
    .EXAMPLE
        New-SQLiteConnectionString
        Creates a new SQLite connection string from the default Datasource in Strapper.
    .EXAMPLE
        New-SQLiteConnectionString -Datasource "C:\mySqlite.db"
        Creates a new SQLite connection string with the datasource "C:\mySqlite.db".
    .PARAMETER Datasource
        The datasource to use for the connection string.
    .OUTPUTS
        [string] - The resulting SQLite connection string.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter()][string]$DataSource = $StrapperSession.DBPath
    )
    $csBuilder = [System.Data.SQLite.SQLiteConnectionStringBuilder]::new()
    $csBuilder.DataSource = $DataSource
    return $csBuilder.ConnectionString
}


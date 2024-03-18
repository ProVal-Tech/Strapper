function New-SQLiteConnection {
    <#
    .SYNOPSIS
        Get a new a SQLite connection.
    .EXAMPLE
        New-SQLiteConnection
        Creates a new SQLite connection from the default Datasource in Strapper.
    .EXAMPLE
        New-SQLiteConnection -Datasource "C:\mySqlite.db" -Open
        Creates a new SQLite connection to the datasource "C:\mySqlite.db" and opens the connection before returning.
    .PARAMETER Datasource
        The datasource to use for the connection.
    .PARAMETER Open
        Use this switch to open the connection before returning it.
    .OUTPUTS
        [System.Data.SQLite.SQLiteConnection] - The resulting SQLite connection object.
    #>
    [CmdletBinding()]
    [OutputType([System.Data.SQLite.SQLiteConnection])]
    param(
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter()][switch]$Open
    )
    if ($Open) {
        return [System.Data.SQLite.SQLiteConnection]::new((New-SQLiteConnectionString -DataSource $DataSource)).OpenAndReturn()
    }
    return [System.Data.SQLite.SQLiteConnection]::new((New-SQLiteConnectionString -DataSource $DataSource))
}


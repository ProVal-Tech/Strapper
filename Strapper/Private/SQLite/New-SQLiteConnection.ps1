function New-SQLiteConnection {
    [CmdletBinding()]
    [OutputType([System.Data.SQLite.SQLiteConnection])]
    param(
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter()][switch]$Open
    )
    if($Open) {
        return [System.Data.SQLite.SQLiteConnection]::new((New-SQLiteConnectionString -DataSource $DataSource)).OpenAndReturn()
    }
    return [System.Data.SQLite.SQLiteConnection]::new((New-SQLiteConnectionString -DataSource $DataSource))
}
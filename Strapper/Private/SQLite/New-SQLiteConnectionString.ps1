function New-SQLiteConnectionString {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter()][string]$DataSource = $StrapperSession.DBPath
    )
    $csBuilder = [System.Data.SQLite.SQLiteConnectionStringBuilder]::new()
    $csBuilder.DataSource = $DataSource
    return $csBuilder.ConnectionString
}
function Get-StrapperLog {
    <#
    .SYNOPSIS
        Get objects representing Strapper logs from a database.
    .EXAMPLE
        Get-StrapperLog
        Gets the Strapper logs from the "<scriptname>_logs" table with a minimum log level of 'Information'.
    .EXAMPLE
        Get-StrapperLog -MinimumLevel 'Error'
        Gets the Strapper logs from the "<scriptname>_logs" table with a minimum log level of 'Error'.
    .EXAMPLE
        Get-StrapperLog -MinimumLevel 'Fatal' -TableName 'MyCustomLogTable'
        Gets the Strapper logs from the "<scriptname>_MyCustomLogTable" table with a minimum log level of 'Fatal'.
    .PARAMETER MinimumLevel
        The minimum log level to gather from the table.
        Highest --- Fatal
                    Error
                    Warning
                    Information
                    Debug
         Lowest --- Verbose

    .PARAMETER TableName
        The name of the table to retrieve logs from.
    .PARAMETER DataSource
        The target SQLite datasource to use. Defaults to Strapper's 'Strapper.db'.
    .OUTPUTS
        [System.Collections.Generic.List[StrapperLog]] - A list of logs from the table.
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Verbose', 'Debug', 'Information', 'Warning', 'Error', 'Fatal')]
        [string]$MinimumLevel = 'Information',
        [Parameter()][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName = $StrapperSession.LogTable,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath
    )
    # Casting here instead of in the parameter because PowerShell modules don't support the export of classes/enums.
    [StrapperLogLevel]$MinimumLevel = [StrapperLogLevel]$MinimumLevel
    [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
    if (!(Get-SQLiteTable -Name $TableName -Connection $sqliteConnection)) {
        Write-Error -Message "No log table with the name '$TableName' was found in the database '$DataSource'" -ErrorAction Stop
    }
    $sqliteCommand = $sqliteConnection.CreateCommand()
    $sqliteCommand.CommandText = "SELECT * FROM '$TableName' WHERE Level >= $($MinimumLevel.value__)"
    Write-Verbose -Message "CommandText: $($sqliteCommand.CommandText)"
    $dataReader = $sqliteCommand.ExecuteReader()
    if (!($dataReader.HasRows)) {
        Write-Warning -Message "No entries found in '$TableName'."
        return
    }
    $logList = [System.Collections.Generic.List[StrapperLog]]::new()
    try {
        while ($dataReader.Read()) {
            Write-Verbose -Message "Id = $($dataReader.GetInt32(0))"
            Write-Verbose -Message "Level = $($dataReader.GetInt32(1))"
            Write-Verbose -Message "Message = $($dataReader.GetString(2))"
            Write-Verbose -Message "Timestamp = $($dataReader.GetDateTime(3))"
            $logList.Add(
                [StrapperLog]@{
                    Id = $dataReader.GetInt32(0)
                    Level = $dataReader.GetInt32(1)
                    Message = $dataReader.GetString(2)
                    Timestamp = $dataReader.GetDateTime(3)
                }
            )
        }
        $logList
    } catch {
        Write-Error -Message "An error occurred while attempting to query SQL: $($_.Exception)"
    } finally {
        $dataReader.Dispose()
        $sqliteConnection.Dispose()
    }
}
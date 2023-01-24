function Get-StrapperLog {
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
        Write-Error -Message "No log table with the name '$TableName' was found in the database '$DataSource'"
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
            Write-Verbose -Message "Level = $($dataReader.GetString(1))"
            Write-Verbose -Message "Message = $($dataReader.GetString(2))"
            Write-Verbose -Message "Timestamp = $($dataReader.GetDateTime(3))"
            $logList.Add(
                [StrapperLog]@{
                    Id = $dataReader.GetInt32(0)
                    Level = $dataReader.GetString(1)
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
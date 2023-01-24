function Get-SQLiteObject {
    [CmdletBinding()]
    param(
        [Parameter()][ValidatePattern('^[a-zA-Z0-9\-_]+$')][string]$TableName,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter()][switch]$IncludeMetadata
    )
    [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
    if (!$TableName) {
        $TableName = 'data'
    }
    $TableName = "$($StrapperSession.ScriptTitle)_$TableName"
    [System.Data.SQLite.SQLiteConnection]$sqliteConnection = New-SQLiteConnection -DataSource $DataSource -Open
    if (!(Get-SQLiteTable -Name $TableName -Connection $sqliteConnection)) {
        Write-Error -Message "No log table with the name '$TableName' was found in the database '$DataSource'" -ErrorAction Stop
    }
    $sqliteCommand = $sqliteConnection.CreateCommand()
    $sqliteCommand.CommandText = "SELECT * FROM '$TableName'"
    Write-Verbose -Message "CommandText: $($sqliteCommand.CommandText)"
    $dataReader = $sqliteCommand.ExecuteReader()
    if (!($dataReader.HasRows)) {
        Write-Warning -Message "No entries found in '$TableName'."
        return
    }
    $objectList = [System.Collections.Generic.List[pscustomobject]]::new()
    try {
        while ($dataReader.Read()) {
            $returnObject = $dataReader.GetString(1) | ConvertFrom-Json
            if($IncludeMetadata) {
                Write-Verbose -Message "Adding metadata to the return object."
                $metadata = [PSCustomObject]@{
                    Id = $dataReader.GetInt32(0)
                    Timestamp = $dataReader.GetDateTime(2)
                    TableName = $dataReader.GetTableName(0)
                }
                Write-Verbose -Message "Id = $($metadata.Id)"
                Write-Verbose -Message "Timestamp = $($metadata.Timestamp)"
                Write-Verbose -Message "TableName = $($metadata.TableName)"
                $returnObject | Add-Member -MemberType NoteProperty -Name Metadata -Value $metadata
            }
            $objectList.Add($returnObject)
        }
        $objectList
    } catch {
        Write-Error -Message "An error occurred while attempting to query SQL: $($_.Exception)"
    } finally {
        $dataReader.Dispose()
        $sqliteConnection.Dispose()
    }
}
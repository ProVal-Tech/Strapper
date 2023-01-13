function Invoke-SQLiteInsert {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$TableName,
        [Parameter()][string]$DataSource = $StrapperSession.DBPath,
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Object')][System.Object[]]$InputObject
    )

    process {
        
    }
}
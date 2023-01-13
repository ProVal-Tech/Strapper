function Get-SQLiteTable {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([pscustomobject], ParameterSetName = 'Single')]
    [OutputType([pscustomobject[]], ParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Single')][string]$Name,
        [Parameter(Mandatory)][System.Data.SQLite.SQLiteConnection]$Connection
    )
    $schema = $Connection.GetSchema('Tables')
    $tablesToProcess = if (!$Name) {
        Write-Verbose -Message 'Returning all tables from schema.'
        $schema.Rows
    } else {
        Write-Verbose -Message "Attempting to locate table with name '$Name'."
        $lowerName = $name.ToLower()
        foreach ($table in $schema.Rows) {
            $tableLowerName = $table.TABLE_NAME.ToLower()
            Write-Verbose -Message "Comparing '$tableLowerName' to '$lowerName'"
            if ($lowerName.Equals($tableLowerName)) {
                @($table)
            }
        }
    }
    return $(foreach ($table in $tablesToProcess) {
            $columnRows = $connection.GetSchema('Columns', @($null, $null, $table.TABLE_NAME)).Rows
            Write-Verbose -Message "Processing $($columnRows.Count) columns for table '$($table.TABLE_NAME)'"
            $columns = $(
                foreach ($columnRow in $columnRows) {
                    [PSCustomObject]@{
                        TableCatalog = $columnRow.TABLE_CATALOG
                        TableSchema = $columnRow.TABLE_SCHEMA
                        TableName = $columnRow.TABLE_NAME
                        ColumnName = $columnRow.COLUMN_NAME
                        ColumnGuid = $columnRow.COLUMN_GUID
                        ColumnPropid = $columnRow.COLUMN_PROPID
                        OrdinalPosition = $columnRow.ORDINAL_POSITION
                        ColumnHasdefault = $columnRow.COLUMN_HASDEFAULT
                        ColumnDefault = $columnRow.COLUMN_DEFAULT
                        ColumnFlags = $columnRow.COLUMN_FLAGS
                        IsNullable = $columnRow.IS_NULLABLE
                        DataType = $columnRow.DATA_TYPE
                        TypeGuid = $columnRow.TYPE_GUID
                        CharacterMaximumLength = $columnRow.CHARACTER_MAXIMUM_LENGTH
                        CharacterOctetLength = $columnRow.CHARACTER_OCTET_LENGTH
                        NumericPrecision = $columnRow.NUMERIC_PRECISION
                        NumericScale = $columnRow.NUMERIC_SCALE
                        DatetimePrecision = $columnRow.DATETIME_PRECISION
                        CharacterSetCatalog = $columnRow.CHARACTER_SET_CATALOG
                        CharacterSetSchema = $columnRow.CHARACTER_SET_SCHEMA
                        CharacterSetName = $columnRow.CHARACTER_SET_NAME
                        CollationCatalog = $columnRow.COLLATION_CATALOG
                        CollationSchema = $columnRow.COLLATION_SCHEMA
                        CollationName = $columnRow.COLLATION_NAME
                        DomainCatalog = $columnRow.DOMAIN_CATALOG
                        DomainName = $columnRow.DOMAIN_NAME
                        Description = $columnRow.DESCRIPTION
                        PrimaryKey = $columnRow.PRIMARY_KEY
                        EdmType = $columnRow.EDM_TYPE
                        Autoincrement = $columnRow.AUTOINCREMENT
                        Unique = $columnRow.UNIQUE
                    }
                }
            )
            [PSCustomObject]@{
                TableCatalog = $table.TABLE_CATALOG
                TableSchema = $table.TABLE_SCHEMA
                TableName = $table.TABLE_NAME
                TableType = $table.TABLE_TYPE
                TableId = $table.TABLE_ID
                TableRootpage = $table.TABLE_ROOTPAGE  
                TableDefinition = $table.TABLE_DEFINITION
                Columns = $columns
            }
        }
    )
}
function ConvertTo-ObjectDataTable {
    [CmdletBinding()]
    [OutputType([System.Data.DataTable])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Object[]]$InputObject
    )
    begin {
        $targetObjectType = [type]::GetType('System.Object')
        $typeCheckPerformed = $false
        $blacklistedTypes = @(
            [type]::GetType('System.IO.DriveInfo'),
            [type]::GetType('System.IO.FileInfo'),
            [type]::GetType('System.IO.DirectoryInfo')
        )
        $dataTable = [System.Data.DataTable]::new()
        $idColumn = [System.Data.DataColumn]@{
            ColumnName = 'id'
            AutoIncrement = $true
            Unique = $true
            DataType = [type]::GetType('System.Int64')
        }
        $jsonColumn = [System.Data.DataColumn]@{
            ColumnName = 'json'
            DataType = [type]::GetType('System.String')
        }
        $timestampColumn = [System.Data.DataColumn]@{
            ColumnName = 'timestamp'
            DataType = [type]::GetType('System.DateTime')
        }
        $dataTable.Columns.AddRange(@($idColumn, $jsonColumn, $timestampColumn))
    }
    process {
        if (!$typeCheckPerformed) {
            $inputTypes = $InputObject | ForEach-Object { $_.GetType() } | Sort-Object | Get-Unique
            if($blacklistedTypes -contains $inputTypes[0]) {
                Write-Error -Exception ([System.ArgumentException]::new("The type of object '$($inputTypes[0])' passed is a blacklisted type. Blacklist: $($blacklistedTypes -join ', ')")) -ErrorAction Stop
            } elseif ($inputTypes.Count -gt 1) {
                Write-Error -Exception ([System.ArgumentException]::new("The array of objects passed must be of a single type. Types passed: $($inputTypes -join ', ')")) -ErrorAction Stop
            }
            $targetObjectType = $inputTypes[0]
            Write-Verbose -Message "Target object type determined to be '$targetObjectType'"
            $typeCheckPerformed = $true
        }
        $dataRow = $dataTable.NewRow()
        $dataRow['json'] = $PSItem | ConvertTo-Json -Depth 100 -Compress
        $dataRow['timestamp'] = (Get-Date).ToString('s')
        $dataTable.Rows.Add($dataRow)
    }
    end {
        $dataTable.AcceptChanges()
        return $dataTable
    }
}
function ConvertTo-ObjectDataRow {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[System.Data.DataRow]])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Object[]]$InputObject
    )
    begin {
        Write-Verbose -Message 'Beginning!'
        $targetObjectType = [type]::GetType('System.Object')
        $typeCheckPerformed = $false
        $blacklistedTypes = @(
            [type]::GetType('System.IO.DriveInfo'),
            [type]::GetType('System.IO.FileInfo'),
            [type]::GetType('System.IO.DirectoryInfo')
        )
        Write-Verbose -Message 'Creating DataTable.'
        $dataTable = [System.Data.DataTable]::new()
        $dataRows = [System.Collections.Generic.List[System.Data.DataRow]]::new()
        Write-Verbose -Message 'Creating ID column.'
        $idColumn = [System.Data.DataColumn]@{
            ColumnName = 'id'
            AutoIncrement = $true
            Unique = $true
            DataType = [type]::GetType('System.Int64')
        }

        Write-Verbose -Message 'Creating JSON column.'
        $jsonColumn = [System.Data.DataColumn]@{
            ColumnName = 'json'
            DataType = [type]::GetType('System.Object')
        }

        Write-Verbose -Message 'Creating Timestamp column.'
        $timestampColumn = [System.Data.DataColumn]@{
            ColumnName = 'timestamp'
            DataType = [type]::GetType('System.DateTime')
        }

        Write-Verbose -Message 'Adding columns to DataTable.'
        $dataTable.Columns.AddRange(@($idColumn, $jsonColumn, $timestampColumn))
    }
    process {
        if (!$typeCheckPerformed) {
            Write-Verbose -Message 'Performing type check.'
            $inputTypes = $InputObject | ForEach-Object { $_.GetType() } | Sort-Object | Get-Unique
            if ($blacklistedTypes -contains $inputTypes[0]) {
                Write-Error -Exception ([System.ArgumentException]::new("The type of object '$($inputTypes[0])' passed is a blacklisted type. Blacklist: $($blacklistedTypes -join ', ')"))
                return
            } elseif ($inputTypes.Count -gt 1) {
                Write-Error -Exception ([System.ArgumentException]::new("The array of objects passed must be of a single type. Types passed: $($inputTypes -join ', ')"))
                return
            }
            $targetObjectType = $inputTypes[0]
            Write-Verbose -Message "Target object type determined to be '$targetObjectType'"
            $typeCheckPerformed = $true
        }
        foreach ($obj in $InputObject) {
            Write-Verbose -Message 'Creating new DataRow.'
            $dataRow = $dataTable.NewRow()
            $dataRow['json'] = $obj | ConvertTo-Json -Depth 100 -Compress
            $dataRow['timestamp'] = (Get-Date).ToString('s')
            Write-Verbose -Message 'Adding row.'
            $dataRows.Add($dataRow)
        }
    }
    end {
        Write-Output -InputObject $dataRows -NoEnumerate
    }
}
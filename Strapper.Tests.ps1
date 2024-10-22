BeforeAll {
    $strapperModuleManifest = Get-ChildItem -Path "$PSScriptRoot/Output/Strapper" -Recurse -File -Filter 'Strapper.psd1' | Select-Object -First 1
    Import-Module -Name $strapperModuleManifest.FullName
    $StrapperSession.LogTable = 'Strapper_Tests'
    $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
}

AfterAll {
    Remove-Module -Name Strapper
}

Describe 'New-SQLiteConnectionString' {
    It 'Returns a default connection string when no parameters are passed' {
        $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
        $connectionString = New-SQLiteConnectionString
        $connectionString | Should -BeOfType System.String
        $connectionString | Should -Match ([regex]::Escape($StrapperSession.DBPath))
    }
    It 'Returns a customized connection string when parameters are passed' {
        $dataSource = "$PSScriptRoot/Output/Strapper/Strapper.db"
        $connectionString = New-SQLiteConnectionString -Datasource $dataSource
        $connectionString | Should -BeOfType System.String
        $connectionString | Should -Match ([regex]::Escape($dataSource))
    }
}

Describe 'New-SQLiteConnection' {
    It 'Creates a closed SQLite connection when -Open is not passed' {
        $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
        [System.Data.SQLite.SQLiteConnection]$connection = New-SQLiteConnection
        $connection | Should -BeOfType System.Data.SQLite.SQLiteConnection
        $connection.State | Should -Be ([System.Data.ConnectionState]::Closed)
        $connection.Dispose()
    }
    It 'Creates an open SQLite connection when -Open switch passed' {
        $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
        [System.Data.SQLite.SQLiteConnection]$connection = New-SQLiteConnection -Open
        $connection | Should -BeOfType System.Data.SQLite.SQLiteConnection
        $connection.State | Should -Be ([System.Data.ConnectionState]::Open)
        $connection.Dispose()
    }
}

Describe 'New-SQLiteLogTable, Write-SQLiteLog, Get-StrapperLog, Remove-SQLiteTable' {
    It 'Creates a new log table, overwriting an existing one when -Clobber is passed' {
        Write-SQLiteLog -Message 'Testing' -Level 'Information'
        $connection = New-SQLiteConnection -Open
        New-SQLiteLogTable -Name 'Strapper_Tests' -Connection $connection -Clobber
        Write-SQLiteLog -Message 'Testing Clobber' -Level 'Information'
        $log = Get-StrapperLog
        $log.Count | Should -Be 1
        $log.Message | Should -Be 'Testing Clobber'
        $connection.Dispose()
    }
}

Describe 'New-SQLiteObjectTable, Write-StoredObject, Get-StoredObject, Remove-SQLiteTable' {
    It 'Creates a new object table, overwriting an existing one when -Clobber is passed' {
        $tableNameTesting = 'Strapper_Object_Testing'
        [PSCustomObject]@{ TestValue = 'Testing' } | Write-StoredObject -TableName $tableNameTesting
        $connection = New-SQLiteConnection -Open
        New-SQLiteObjectTable -Name $tableNameTesting -Connection $connection -Clobber
        [PSCustomObject]@{ TestValue = 'Testing Clobber' } | Write-StoredObject -TableName $tableNameTesting
        $storedObject = Get-StoredObject -TableName $tableNameTesting
        $storedObject.Count | Should -Be 1
        $storedObject.TestValue | Should -Be 'Testing Clobber'
        $connection.Dispose()
    }
}

Describe 'Copy-RegistryItem' {
    BeforeAll {
        $rootPath = 'HKCU:\SOFTWARE\a'
        $sourcePath = Join-Path -Path $rootPath -ChildPath 'b'
        $sourceName = 'TestProp'
        $sourceValue = 'Value'
        $targetPath = Join-Path -Path $rootPath -ChildPath 'c'
    }
    BeforeEach {
        New-Item -Path $sourcePath -Force | Out-Null
        New-ItemProperty -Path $sourcePath -Name $sourceName -Value $sourceValue
    }
    AfterEach {
        Remove-Item -Path $rootPath -ErrorAction SilentlyContinue -Recurse
    }
    It "Copies a target registry item" {
        Copy-RegistryItem -Path $sourcePath -Name $sourceName -Destination $targetPath -Force
        (Get-ItemProperty -Path $targetPath).$sourceName | Should -Be $sourceValue
    }
}

Describe "Get-RegistryHivePath" {
    It "Gets the current list of registry hives" {
        $hives = Get-RegistryHivePath -ExcludeDefault
        $hives.Count | Should -BeGreaterOrEqual 1
        ($hives | Where-Object {$_.Username -ne 'DefaultUserTemplate'} | Select-Object -First 1).UserHive | Should -Match "ntuser\.dat"
    }
}

Describe "Get-UserRegistryKeyProperty" {
    It "Gets a registry key value for all users" {
        $regEntries = Get-UserRegistryKeyProperty -Path "Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop"
        $regEntries | Should -Not -BeNullOrEmpty
        $firstUserEntry = $regEntries | Where-Object { $_.Hive -match "Users" } | Select-Object -First 1
        $firstUserEntry | Should -Not -BeNullOrEmpty
    }
}

Describe "Get-WebFile" {
    BeforeAll {
        $targetUri = "https://www.google.com/robots.txt"
        $targetDownloadPath = ".\$(New-Guid).txt"
        Remove-Item -Path $targetDownloadPath -Force -ErrorAction SilentlyContinue
    }
    AfterAll {
        Remove-Item -Path $targetDownloadPath -Force -ErrorAction SilentlyContinue
    }
    It "Downloads a file and saves it to the target directory" {
        $downloadedFile = Get-WebFile -Uri $targetUri -Path $targetDownloadPath -Clobber -PassThru
        Write-Information -MessageData $downloadedFile.FullName -InformationAction Continue
        $downloadedFile | Should -Exist
    }
}

Describe 'Write-Log' {
    BeforeEach {
        $testGuid = New-Guid
    }
    It 'Writes a database entry' {
        $StrapperSession.LogsToDB = $true # default value
        Write-Log -Text $testGuid
        Get-StrapperLog | Select-Object -ExpandProperty Message -Last 1 | Should -Be $testGuid
    }
    It 'Writes a log file entry' {
        Write-Log -Text $testGuid         
        Get-Content -Path $StrapperSession.LogPath | Select-Object -Last 1 | Should -Match "$testGuid$"
    }
    It 'Does not write a database entry if not enabled' {
        $StrapperSession.LogsToDB = $false
        Write-Log -Text $testGuid
        Get-StrapperLog | Select-Object -ExpandProperty Message -Last 1 | Should -Not -Be $testGuid
    }
    It 'Writes a log file entry from a pipeline object' {
        $testGuid | Write-Log
        Get-Content -Path $StrapperSession.LogPath | Select-Object -Last 1 | Should -Match "$testGuid$"
    }
}
BeforeAll {
    $strapperModuleManifest = Get-ChildItem -Path "$PSScriptRoot/Output/Strapper" -Recurse -File -Filter "Strapper.psd1" | Select-Object -First 1
    Import-Module -Name $strapperModuleManifest.FullName
}

AfterAll {
    Remove-Module -Name Strapper
}

Describe "New-SQLiteConnectionString" {
    Context "No parameters" {
        It "Returns a connection string" {
            $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
            $connectionString = New-SQLiteConnectionString
            $connectionString | Should -BeOfType System.String
            $connectionString | Should -Match ([regex]::Escape($StrapperSession.DBPath))
        }
    }
    Context "Passed parameters" {
        It "Returns a connection string" {
            $dataSource = "$PSScriptRoot/Output/Strapper/Strapper.db"
            $connectionString = New-SQLiteConnectionString -Datasource $dataSource
            $connectionString | Should -BeOfType System.String
            $connectionString | Should -Match ([regex]::Escape($dataSource))
        }
    }
}

Describe "New-SQLiteConnection" {
    Context "No -Open switch" {
        It "Creates a SQLite connection" {
            $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
            [System.Data.SQLite.SQLiteConnection]$connection = New-SQLiteConnection
            $connection | Should -BeOfType System.Data.SQLite.SQLiteConnection
            $connection.State | Should -Be ([System.Data.ConnectionState]::Closed)
            $connection.Dispose()
        }
    }
    Context "-Open switch passed" {
        It "Creates an open SQLite connection" {
            $StrapperSession.DBPath = "$PSScriptRoot/Output/Strapper/Strapper.db"
            [System.Data.SQLite.SQLiteConnection]$connection = New-SQLiteConnection -Open
            $connection | Should -BeOfType System.Data.SQLite.SQLiteConnection
            $connection.State | Should -Be ([System.Data.ConnectionState]::Open)
            $connection.Dispose()
        }
    }
}

Describe "Write-Log" {
    BeforeEach {
        $testGuid = New-Guid
        $StrapperSession.LogTable = "Strapper_Tests"
    }
    It "Writes a database entry" {
        $StrapperSession.LogsToDB = $true # default value
        Write-Log -Text $testGuid
        Get-StrapperLog | Select-Object -ExpandProperty Message -Last 1 | Should -Be $testGuid
    }
    It "Writes a log file entry" {
        Write-Log -Text $testGuid         
        Get-Content -Path $StrapperSession.LogPath | Select-Object -Last 1 | Should -Match "$testGuid$"
    }
    It "Does not write a database entry if not enabled" {
        $StrapperSession.LogsToDB = $false
        Write-Log -Text $testGuid
        Get-StrapperLog | Select-Object -ExpandProperty Message -Last 1 | Should -Not -Be $testGuid
    }
}
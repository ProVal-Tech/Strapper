BeforeAll {
    Import-Module "$PSScriptRoot/Strapper/Strapper.psd1"
}

Describe "Write-Log" {
    BeforeEach {
        $testGuid = New-Guid
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
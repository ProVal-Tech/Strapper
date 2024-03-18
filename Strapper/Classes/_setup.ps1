$StrapperSession = [pscustomobject]@{
    LogPath = $null
    ErrorPath = $null
    WorkingPath = $null
    ScriptTitle = $null
    IsLoaded = $true
    IsElevated = $false
    LogsToDB = $true
    LogTable = $null
    DBPath = "$PSScriptRoot/Strapper.db"
    Platform = [System.Environment]::OSVersion.Platform
}

if ($MyInvocation.PSCommandPath) {
    $scriptObject = Get-Item -Path $MyInvocation.PSCommandPath
    $StrapperSession.WorkingPath = $($scriptObject.DirectoryName)
    $StrapperSession.LogPath = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-log.txt"
    $StrapperSession.ErrorPath = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-error.txt"
    $StrapperSession.ScriptTitle = $scriptObject.BaseName
    $StrapperSession.LogTable = "$($scriptObject.BaseName)_log"
} else {
    $StrapperSession.WorkingPath = (Get-Location).Path
    $currentDate = (Get-Date).ToString('yyyyMMdd')
    $StrapperSession.LogPath = Join-Path $StrapperSession.WorkingPath "$currentDate-log.txt"
    $StrapperSession.ErrorPath = Join-Path $StrapperSession.WorkingPath "$currentDate-error.txt"
    $StrapperSession.ScriptTitle = $currentDate
    $StrapperSession.LogTable = "$($currentDate)_log"
}

if ($StrapperSession.Platform -eq 'Win32NT') {
    $StrapperSession.IsElevated = (
        New-Object `
            -TypeName Security.Principal.WindowsPrincipal `
            -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent())
    ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} else {
    $StrapperSession.IsElevated = $(id -u) -eq 0
}

if(!(Test-Path -LiteralPath $StrapperSession.DBPath)) {
    [System.Data.SQLite.SQLiteConnection]::CreateFile($StrapperSession.DBPath)
}

if($IsLinux -or $IsMacOS) {
    chmod 776 $StrapperSession.DBPath
} else {
    $dbPathAcl = Get-Acl -Path $StrapperSession.DBPath
    $worldGroupName = (New-Object System.Security.Principal.SecurityIdentifier('S-1-1-0')).Translate([System.Security.Principal.NTAccount]).Value
    $fsar = [System.Security.AccessControl.FileSystemAccessRule]::new($worldGroupName, "FullControl", "Allow")
    $dbPathAcl.SetAccessRule($fsar)
    Set-Acl -Path $StrapperSession.DBPath -AclObject $dbPathAcl
}
Export-ModuleMember -Variable StrapperSession
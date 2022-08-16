$StrapperSession = [pscustomobject]@{
    LogPath = $null
    DataPath = $null
    ErrorPath = $null
    WorkingPath = $null
    ScriptTitle = $null
    IsLoaded = $true
    IsElevated = $false
    Platform = [System.Environment]::OSVersion.Platform
}

if ($MyInvocation.PSCommandPath) {
    $scriptObject = Get-Item -Path $MyInvocation.PSCommandPath
    $StrapperSession.WorkingPath = $($scriptObject.DirectoryName)
    $StrapperSession.LogPath     = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-log.txt"
    $StrapperSession.DataPath    = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-data.txt"
    $StrapperSession.ErrorPath   = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-error.txt"
    $StrapperSession.ScriptTitle = $scriptObject.BaseName
} else {
    $StrapperSession.WorkingPath = (Get-Location).Path
    $StrapperSession.LogPath     = Join-Path $StrapperSession.WorkingPath "$((Get-Date).ToString('yyyyMMdd'))-log.txt"
    $StrapperSession.DataPath    = Join-Path $StrapperSession.WorkingPath "$((Get-Date).ToString('yyyyMMdd'))-data.txt"
    $StrapperSession.ErrorPath   = Join-Path $StrapperSession.WorkingPath "$((Get-Date).ToString('yyyyMMdd'))-error.txt"
    $StrapperSession.ScriptTitle = '***Manual Run***'
}

if ($StrapperSession.Platform -eq 'Win32NT') {
    $StrapperSession.IsElevated = (New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} else {
    $StrapperSession.IsElevated = $(id -u) -eq 0
}
Remove-Item -Path $StrapperSession.DataPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $StrapperSession.ErrorPath -Force -ErrorAction SilentlyContinue
Write-Log -Text '-----------------------------------------------' -Type INIT
Write-Log -Text $StrapperSession.ScriptTitle -Type INIT
Write-Log -Text "System: $([Environment]::MachineName)" -Type INIT
Write-Log -Text "User: $([Environment]::UserName)" -Type INIT
Write-Log -Text "OS Bitness: $((32,64)[[Environment]::Is64BitOperatingSystem])" -Type INIT
Write-Log -Text "PowerShell Bitness: $(if([Environment]::Is64BitProcess) {64} else {32})" -Type INIT
Write-Log -Text "PowerShell Version: $(Get-Host | Select-Object -ExpandProperty Version | Select-Object -ExpandProperty Major)" -Type INIT
Write-Log -Text '-----------------------------------------------' -Type INIT
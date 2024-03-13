function Set-StrapperEnvironment {
    <#
    .SYNOPSIS
        Removes error and data files from the current working path and writes initialization information to the log.
    .EXAMPLE
        PS C:\> Set-StrapperEnvironment
    #>
    Remove-Item -Path $StrapperSession.ErrorPath -Force -ErrorAction SilentlyContinue
    Write-Log -Level Debug -Text $StrapperSession.ScriptTitle
    Write-Log -Level Debug -Text "System: $([Environment]::MachineName)"
    Write-Log -Level Debug -Text "User: $([Environment]::UserName)"
    Write-Log -Level Debug -Text "OS Bitness: $((32,64)[[Environment]::Is64BitOperatingSystem])"
    Write-Log -Level Debug -Text "PowerShell Bitness: $(if([Environment]::Is64BitProcess) {64} else {32})"
    Write-Log -Level Debug -Text "PowerShell Version: $(Get-Host | Select-Object -ExpandProperty Version | Select-Object -ExpandProperty Major)"
}


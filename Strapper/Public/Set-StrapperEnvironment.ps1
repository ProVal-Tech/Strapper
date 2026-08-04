function Set-StrapperEnvironment {
    <#
    .SYNOPSIS
        Sets module permissions, removes error and data files from the current working path, and writes initialization information to the log.
    .DESCRIPTION
        Grants modify permissions to the BUILTIN Users group for the Strapper module directory and database files to resolve SQLite journaling issues.
        Removes existing error and data files from the current working path and writes initialization information to the log.
    .EXAMPLE
        PS C:\> Set-StrapperEnvironment
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param ()

    #region main
    Set-StrapperDatabasePermissions -ErrorAction SilentlyContinue

    Remove-Item -Path $StrapperSession.ErrorPath -Force -ErrorAction SilentlyContinue
    Write-Log -Text $StrapperSession.ScriptTitle -Level Debug
    Write-Log -Text ('System: {0}' -f [Environment]::MachineName) -Level Debug
    Write-Log -Text ('User: {0}' -f [Environment]::UserName) -Level Debug
    Write-Log -Text ('OS Bitness: {0}' -f (32, 64)[[Environment]::Is64BitOperatingSystem]) -Level Debug
    Write-Log -Text ('PowerShell Bitness: {0}' -f $(if ([Environment]::Is64BitProcess) { 64 } else { 32 })) -Level Debug
    Write-Log -Text ('PowerShell Version: {0}' -f $(Get-Host | Select-Object -ExpandProperty Version | Select-Object -ExpandProperty Major)) -Level Debug
    #endregion
}
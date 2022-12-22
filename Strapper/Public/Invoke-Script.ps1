function Invoke-Script {
    <#
    .SYNOPSIS
        Run a PowerShell script from a local or remote path.
    .EXAMPLE
        Get-WebFile -Uri 'C:\Users\User\Restart-MyComputer.ps1'
        Runs the PowerShell script 'C:\Users\User\Restart-MyComputer.ps1'.
    .EXAMPLE
        Get-WebFile -Uri 'https://file.contoso.com/scripts/Set-UserWallpaper.ps1' -Parameters @{
            User = 'Joe.Smith'
            Wallpaper = 'https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png'
        }
        Downloads and runs the PowerShell script 'Set-UserWallpaper.ps1', passing the given parameters to it.
    .PARAMETER Uri
        The local path or URL of the target PowerShell script.
    .PARAMETER Parameters
        A hashtable of parameters to pass to the target PowerShell script.
    .OUTPUTS
        This function will have varying output based on the called PowerShell script.
    #>
    #requires -Version 5
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][System.Uri]$Uri,
        [Parameter()][hashtable]$Parameters = @{}
    )
    $targetScriptPath = $uri.LocalPath
    if (!($Uri.IsFile)) {
        # Retrieve the base file name of the target file. This is required to account for redirection.
        $baseFileName = ([System.Net.WebRequest]::Create($Uri)).GetResponse().ResponseUri.Segments[-1]

        if($baseFileName -notmatch '\.ps1$') {
            Write-Log -Text 'This function only supports invoking .ps1 files.' -Type ERROR
            throw
        }
        # Download the file from the URI.
        if ([System.IO.FileInfo]$downloadedFile = Get-WebFile -Uri $Uri -Path "$env:TEMP\$baseFileName" -PassThru -Clobber) {
            $targetScriptPath = $downloadedFile.FullName
        } else {
            Write-Log -Text "Failed to download file from '$Uri'" -Type ERROR
            throw
        }
    } else {
        if($uri.Segments[-1] -notmatch '\.ps1$') {
            Write-Log -Text 'This function only supports invoking .ps1 files.' -Type ERROR
            throw
        }
    }
    . $targetScriptPath @Parameters
}
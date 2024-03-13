function Get-WebFile {
    <#
    .SYNOPSIS
        Download a file from the internet.
    .EXAMPLE
        Get-WebFile -Uri 'https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png' -Path 'C:\Temp\miku.png'
        Download the target PNG to 'C:\Temp\miku.png'.
    .EXAMPLE
        Get-WebFile -Uri 'https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png' -Path 'C:\Temp\miku.png' -Clobber
        Download the target PNG to 'C:\Temp\miku.png', overwriting it if it exists.
    .EXAMPLE
        $mikuPath = Get-WebFile -Uri 'https://static.wikia.nocookie.net/vocaloid/images/5/57/Miku_v4_bundle_art.png' -Path 'C:\Temp\miku.png' -Clobber -PassThru
        Download the target PNG to 'C:\Temp\miku.png', overwriting it if it exists, and returning the FileInfo object.
    .PARAMETER Uri
        The URI to download the target file from.
    .PARAMETER Path
        The local path to save the file to.
    .PARAMETER Clobber
        Allow overwriting of an existing file.
    .PARAMETER PassThru
        Return a FileInfo object representing the downloaded file upon success.
    #>
    [CmdletBinding()]
    [OutputType([System.Void], ParameterSetName="NoPassThru")]
    [OutputType([System.IO.FileInfo], ParameterSetName="PassThru")]
    param (
        [Parameter(Mandatory, ParameterSetName='NoPassThru')]
        [Parameter(Mandatory, ParameterSetName='PassThru')]
        [System.Uri]$Uri,

        [Parameter(Mandatory, ParameterSetName='NoPassThru')]
        [Parameter(Mandatory, ParameterSetName='PassThru')]
        [System.IO.FileInfo]$Path,

        [Parameter(ParameterSetName='NoPassThru')]
        [Parameter(ParameterSetName='PassThru')]
        [switch]$Clobber,

        [Parameter(Mandatory, ParameterSetName='PassThru')]
        [switch]$PassThru
    )
    Write-Debug -Message "URI: $Uri"
    Write-Debug -Message "Target file: $($Path.FullName)"
    if ($Path.Exists -and !$Clobber) {
        Write-Error -Message "The file '$($Path.FullName)' exists. To overwrite this file, pass the -Clobber switch." -ErrorAction Stop
    }
    Write-Debug -Message 'Starting file download.'
    (New-Object System.Net.WebClient).DownloadFile($Uri, $Path.FullName)

    Write-Debug -Message 'Refreshing FileInfo object.'
    $path.Refresh()

    Write-Debug -Message 'Validating that file was downloaded.'
    if ($path.Exists) {
        Write-Debug -Message "Successfully downloaded '$Uri' to '$($Path.FullName)'"
        Write-Information -MessageData "Successfully downloaded '$Uri' to '$($Path.FullName)'"
        Write-Debug -Message 'Checking if PassThru was set.'
        if ($PassThru) {
            Write-Debug -Message 'PassThru set. Returning object.'
            return $Path
        }
    } else {
        Write-Error -Message "An error occurred and '$Uri' was unable to be downloaded." -ErrorAction Stop
    }
}


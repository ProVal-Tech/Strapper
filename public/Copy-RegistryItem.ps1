function Copy-RegistryItem {
    <#
    .SYNOPSIS
        Copies a registry property or key to the target destination.
    .PARAMETER Path
        The path to the key to copy.
    .PARAMETER Destination
        The path the the key to copy to.
    .PARAMETER Name
        The name of the property to copy.
    .PARAMETER Recurse
        Recursively copy all subkeys from the target key path.
    .PARAMETER Force
        Create the destination key if it does not exist.
    .EXAMPLE
        Copy-RegistryItem -Path HKLM:\SOFTWARE\Canon -Destination HKLM:\SOFTWARE\_automation\RegistryBackup -Force -Recurse
        Copy all keys, subkeys, and properties from HKLM:\SOFTWARE\Canon to HKLM:\SOFTWARE\_automation\RegistryBackup
    .EXAMPLE
        Copy-RegistryItem -Path HKLM:\SOFTWARE\Adobe -Name PDFFormat -Destination HKLM:\SOFTWARE\_automation\RegistryBackup\Adobe -Force
        Copy the PDFFormat property from HKLM:\SOFTWARE\Adobe to HKLM:\SOFTWARE\_automation\RegistryBackup\Adobe
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Win32.RegistryKey])]
    param (
        [Parameter(ParameterSetName = 'Property')]
        [Parameter(ParameterSetName = 'Key')]
        [Parameter(Mandatory)][string]$Path,
        [Parameter(ParameterSetName = 'Property')]
        [Parameter(ParameterSetName = 'Key')]
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(ParameterSetName = 'Property')]
        [string]$Name,
        [Parameter(ParameterSetName = 'Key')]
        [switch]$Recurse,
        [Parameter(ParameterSetName = 'Property')]
        [Parameter(ParameterSetName = 'Key')]
        [switch]$Force
    )

    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }

    if ((Get-Item -Path ($Path -split '\\')[0]).GetType() -ne [Microsoft.Win32.RegistryKey]) {
        Write-Log -Text 'The supplied path does not correlate to a registry key.' -Type ERROR
        return $null
    } elseif ((Get-Item -Path ($Destination -split '\\')[0]).GetType() -ne [Microsoft.Win32.RegistryKey]) {
        Write-Log -Text 'The supplied destination does not correlate to a registry key.' -Type ERROR
        return $null
    } elseif (!(Test-Path -Path $Path)) {
        Write-Log -Text "Path '$Path' does not exist." -Type ERROR
        return $null
    } elseif (!(Test-Path -Path $Destination) -and $Force) {
        Write-Log -Text "'$Destination' does not exist. Creating."
        New-Item -Path $Destination -Force | Out-Null
    } elseif (!(Test-Path -Path $Destination)) {
        Write-Log -Text "Destination '$Destination' does not exist." -Type ERROR
        return $null
    }

    if ($Name) {
        if (Copy-ItemProperty -Path $Path -Destination $Destination -Name $Name -PassThru) {
            return Get-Item -Path $Destination
        } else {
            Write-Log -Message "An error occurred when writing the registry property: $($error[0].Exception.Message)" -Type ERROR
        }
    } else {
        return Copy-Item -Path $Path -Destination $Destination -Recurse:$Recurse -PassThru
    }
}
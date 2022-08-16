function Set-RegistryKeyProperty {
    <#
    .SYNOPSIS
        Sets a Windows registry property value.
    .EXAMPLE
        Set-RegistryKeyProperty -Path "HKLM:\SOFTWARE\_automation\Test\1\2\3\4" -Name "MyValueName" -Value "1" -Type DWord
        Creates a DWord registry property with the name MyValueName and the value of 1. Will not create the key path if it does not exist.
    .EXAMPLE
        Set-RegistryKeyProperty -Path "HKLM:\SOFTWARE\_automation\Strings\New\Path" -Name "MyString" -Value "1234" -Force
        Creates a String registry property based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.
    .PARAMETER Path
        The registry path to the key to store the target property.
    .PARAMETER Name
        The name of the property to create/update.
    .PARAMETER Value
        The value to set for the property.
    .PARAMETER Type
        The type of value to set. If not passed, this will be inferred from the object type of the Value parameter.
    .PARAMETER Force
        Will create the registry key path to the property if it does not exist.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$Name = '(Default)',

        [Parameter(Mandatory = $true)]
        [object]$Value,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Unknown', 'String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'QWord', 'None')]
        [Microsoft.Win32.RegistryValueKind]$Type,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }

    if ((Get-Item -Path ($Path -split '\\')[0]).GetType() -ne [Microsoft.Win32.RegistryKey]) {
        Write-Log -Text 'The supplied path does not correlate to a registry key.' -Type ERROR
        return $null
    }

    if (!(Test-Path -Path $Path) -and $Force) {
        Write-Log -Text "'$Path' does not exist. Creating."
        New-Item -Path $Path -Force | Out-Null
    } elseif (!(Test-Path -Path $Path)) {
        Write-Log -Text "'$Path' does not exist. Unable to create registry entry." -Type ERROR
        return $null
    }

    $parameters = @{
        Path = $Path
        Name = $Name
        Value = $Value
        PassThru = $true
    }
    if ($Type) { $parameters.Add('Type', $Type) }
    return Set-ItemProperty @parameters
}
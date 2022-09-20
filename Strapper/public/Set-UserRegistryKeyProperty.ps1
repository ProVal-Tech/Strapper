function Set-UserRegistryKeyProperty {
    <#
    .SYNOPSIS
        Creates or updates a registry property value for existing user registry hives.
    .EXAMPLE
        Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Prompter" -Name "Timestamp" -Value 1
        Creates or updates a Dword registry property property for each available user's registry hive to a value of 1.
    .EXAMPLE
        Set-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Strings\New\Path" -Name "MyString" -Value "1234" -Force
        Creates or updates a String registry property based on value type inference with the name MyString and the value of "1234". Creates the descending key path if it does not exist.
    .PARAMETER Path
        The relative registry path to the target property.
    .PARAMETER Name
        The name of the property to target.
    .PARAMETER Value
        The value to set on the target property.
    .PARAMETER Type
        The type of value to set. If not passed, this will be inferred from the object type of the Value parameter.
    .PARAMETER ExcludeDefault
        Exclude the Default user template from having the registry keys set.
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
        [switch]$ExcludeDefault,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }
    
    # Regex pattern for SIDs
    $patternSID = '((S-1-5-21)|(S-1-12-1))-\d+-\d+\-\d+\-\d+$'

    # Get Username, SID, and location of ntuser.dat for all users
    $profileList = Get-RegistryHivePath -ExcludeDefault:$ExcludeDefault

    # Get all user SIDs found in HKEY_USERS (ntuser.dat files that are loaded)
    $loadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object { $_.PSChildname -match $PatternSID } | Select-Object @{name = 'SID'; expression = { $_.PSChildName } }

    # Get all user hives that are not currently logged in
    if ($LoadedHives) {
        $UnloadedHives = Compare-Object $ProfileList.SID $LoadedHives.SID | Select-Object @{name = 'SID'; expression = { $_.InputObject } }, UserHive, Username
    } else {
        $UnloadedHives = $ProfileList
    }

    # Iterate through each profile on the machine
    $returnEntries = @(
        foreach ($profile in $ProfileList) {
            # Load User ntuser.dat if it's not already loaded
            if ($profile.SID -in $UnloadedHives.SID) {
                reg load HKU\$($profile.SID) $($profile.UserHive) | Out-Null
            }

            $propertyPath = "Registry::HKEY_USERS\$($profile.SID)\$Path"

            # Set the parameters to pass to Set-RegistryKeyProperty
            $parameters = @{
                Path = $propertyPath
                Name = $Name
                Value = $Value
                Force = $Force
            }
            if ($Type) { $parameters.Add('Type', $Type) }

            # Set the target registry entry
            $returnEntry = Set-RegistryKeyProperty @parameters | Select-Object -ExpandProperty $Name

            # If the set was successful, then pass back the return entry from Set-RegistryKeyProperty
            if ($returnEntry) {
                [PSCustomObject]@{
                    Username = $profile.Username
                    SID = $profile.SID
                    Path = $propertyPath
                    Hive = $profile.UserHive
                    Name = $Name
                    Value = $returnEntry
                }
            } else {
                Write-Log -Text "Failed to set the requested registry entry for user '$($profile.Username)'" -Type WARN
            }

            # Collect garbage and close ntuser.dat if the hive was initially unloaded
            if ($profile.SID -in $UnloadedHives.SID) {
                [gc]::Collect()
                reg unload HKU\$($profile.SID) | Out-Null
            }
        }
    )
    Write-Log -Text "$($returnEntries.Count) user registry entries successfully updated."
    return $returnEntries
}
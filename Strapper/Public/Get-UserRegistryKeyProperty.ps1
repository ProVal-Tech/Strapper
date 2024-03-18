function Get-UserRegistryKeyProperty {
    <#
    .SYNOPSIS
        Gets a list of existing user registry properties.
    .EXAMPLE
        Get-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Prompter" -Name "Timestamp"
        Gets the Prompter Timestamp property from each available user's registry hive.
    .PARAMETER Path
        The relative registry path to the target property.
        Ex: To retrieve the property information for each user's Level property under the path HKEY_CURRENT_USER\SOFTWARE\7-Zip\Compression: pass "SOFTWARE\7-Zip\Compression"
    .PARAMETER Name
        The name of the property to target.
        Ex: To retrieve the property information for each user's Level property under the path HKEY_CURRENT_USER\SOFTWARE\7-Zip\Compression: pass "Level"
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $false)][string]$Name = '(Default)'
    )

    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }
    
    # Regex pattern for SIDs
    $patternSID = '((S-1-5-21)|(S-1-12-1))-\d+-\d+\-\d+\-\d+$'

    # Get Username, SID, and location of ntuser.dat for all users
    $profileList = Get-RegistryHivePath

    # Get all user SIDs found in HKEY_USERS (ntuser.dat files that are loaded)
    $loadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object { $_.PSChildname -match $PatternSID } | Select-Object @{name = 'SID'; expression = { $_.PSChildName } }

    # Get all user hives that are not currently logged in
    if ($LoadedHives) {
        $UnloadedHives = Compare-Object $ProfileList.SID $LoadedHives.SID | Select-Object @{name = 'SID'; expression = { $_.InputObject } }, UserHive, Username
    } else {
        $UnloadedHives = $ProfileList
    }

    $returnEntries = @(
        foreach ($profile in $ProfileList) {
            # Load user ntuser.dat if it's not already loaded
            if ($profile.SID -in $UnloadedHives.SID) {
                reg load HKU\$($profile.SID) $($profile.UserHive) | Out-Null
            }

            # Get the absolute path to the key for the currently iterated user.
            $propertyPath = "Registry::HKEY_USERS\$($profile.SID)\$Path"

            # Get the target registry entry
            $returnEntry = $null
            $returnEntry = Get-ItemProperty -Path $propertyPath -Name $Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $Name

            # If the get was successful, then pass back a custom object that describes the registry entry.
            if ($null -ne $returnEntry) {
                [PSCustomObject]@{
                    Username = $profile.Username
                    SID = $profile.SID
                    Path = $propertyPath
                    Hive = $profile.UserHive
                    Name = $Name
                    Value = $returnEntry
                }
            }

            # Collect garbage and close ntuser.dat if the hive was initially unloaded
            if ($profile.SID -in $UnloadedHives.SID) {
                [gc]::Collect()
                reg unload HKU\$($profile.SID) | Out-Null
            }
        }
    )
    return $returnEntries
}


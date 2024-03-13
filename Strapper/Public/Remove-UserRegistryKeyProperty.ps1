function Remove-UserRegistryKeyProperty {
    <#
    .SYNOPSIS
        Removes a registry property value for existing user registry hives.
    .EXAMPLE
        Remove-UserRegistryKeyProperty -Path "SOFTWARE\_automation\Prompter" -Name "Timestamp"
        Removes registry property "Timestamp" under "SOFTWARE\_automation\Prompter" for each available user's registry hive.
    .PARAMETER Path
        The relative registry path to the target property.
    .PARAMETER Name
        The name of the property to target.
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name
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

    # Iterate through each profile on the machine
    foreach ($profile in $ProfileList) {
        # Load User ntuser.dat if it's not already loaded
        if ($profile.SID -in $UnloadedHives.SID) {
            reg load HKU\$($profile.SID) $($profile.UserHive) | Out-Null
        }

        $propertyPath = "Registry::HKEY_USERS\$($profile.SID)\$Path"

        # If the entry does not exist then skip this user.
        if (!(Get-ItemProperty -Path $propertyPath -Name $Name -ErrorAction SilentlyContinue)) {
            Write-Log -Level Information -Text "The requested registry entry for user '$($profile.Username)' does not exist."
            continue
        }

        # Set the parameters to pass to Remove-ItemProperty
        $parameters = @{
            Path = $propertyPath
            Name = $Name
        }

        # Remove the target registry entry
        Remove-ItemProperty @parameters

        # Log the success or failure status of the removal.
        if ($?) {
            Write-Log -Level Information -Text "Removed the requested registry entry for user '$($profile.Username)'" -Type LOG
        } else {
            Write-Log -Level Error -Text "Failed to remove the requested registry entry for user '$($profile.Username)'"
        }

        # Collect garbage and close ntuser.dat if the hive was initially unloaded
        if ($profile.SID -in $UnloadedHives.SID) {
            [gc]::Collect()
            reg unload HKU\$($profile.SID) | Out-Null
        }
    }
}


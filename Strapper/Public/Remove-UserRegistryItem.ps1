
function Remove-UserRegistryItem {
    <#
    .SYNOPSIS
        Deletes specific registry property values or keys for all existing user registry hives.
 
    .EXAMPLE
        Remove-UserRegistryItem -Path "SOFTWARE\_automation\Prompter"
        Removes all registry properties under "SOFTWARE\_automation\Prompter" for each user's registry hive.
 
    .EXAMPLE
        Remove-UserRegistryItem -Path "SOFTWARE\_automation\Prompter" -Recurse
        Removes all registry properties and subkeys under "SOFTWARE\_automation\Prompter" for each user's registry hive.
 
    .PARAMETER Path
        Specifies the relative registry path to the target properties or keys.
 
    .PARAMETER Recurse
        When specified, removes all registry properties, keys, and associated subkeys for each user's registry hive.
 
    .NOTES
        This function is only supported on Windows platforms and requires administrative privileges.
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $false)][switch]$Recurse
    )
 
    # Validate platform compatibility
    if ($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }
 
    # Define the regular expression pattern for Security Identifiers (SIDs)
    $patternSID = '((S-1-5-21)|(S-1-12-1))-\d+-\d+\-\d+\-\d+$'
 
    # Retrieve profile list containing user SIDs, usernames, and ntuser.dat paths
    $profileList = Get-RegistryHivePath
 
    # Retrieve all loaded user registry hives from HKEY_USERS
    $loadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object { $_.PSChildName -match $patternSID } | Select-Object @{Name = 'SID'; Expression = { $_.PSChildName } }
 
    # Identify unloaded user registry hives
    if ($loadedHives) {
        $unloadedHives = Compare-Object $profileList.SID $loadedHives.SID | Select-Object @{Name = 'SID'; Expression = { $_.InputObject } }, UserHive, Username
    } else {
        $unloadedHives = $profileList
    }
 
    # Process each user profile on the system
    foreach ($profile in $profileList) {
        # Load the user's ntuser.dat hive if not already loaded
        if ($profile.SID -in $unloadedHives.SID) {
            reg load HKU\$($profile.SID) $($profile.UserHive) | Out-Null
        }
 
        # Construct the full registry path for the specified user
        $registryPath = "Registry::HKEY_USERS\$($profile.SID)\$Path"
 
        # Check if the registry path exists; skip if it does not
        $returnEntry = Get-ItemProperty -Path $registryPath -ErrorAction SilentlyContinue
        if (!($returnEntry)) {
            Write-Log -Level Information -Text "No properties found under the specified registry path for user '$($profile.Username)'."
            continue
        }
 
        # Retrieve all property names under the specified path
        $names = $returnEntry | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' -and $_.Name -notin ('PSPath', 'PSParentPath', 'PSProvider', 'PSChildName') } | Select-Object -ExpandProperty Name
 
        # Remove each registry property
        foreach ($name in $names) {
            $parameters = @{
                Path = $registryPath
                Name = $name
            }
 
            Remove-ItemProperty @parameters
 
            # Log the outcome of the removal process
            if ($?) {
                Write-Log -Level Information -Text "Successfully removed registry property '$name' for user '$($profile.Username)'."
            } else {
                Write-Log -Level Error -Text "Failed to remove registry property '$name' for user '$($profile.Username)'."
            }
        }
 
        # If the Recurse flag is specified, remove all subkeys under the path
        if ($Recurse) {
            Get-ChildItem -Path $registryPath -Recurse | Remove-Item -Force -Recurse
 
            # Log the outcome of recursive removal
            if ($?) {
                Write-Log -Level Information -Text "Successfully removed all subkeys under '$Path' for user '$($profile.Username)'."
            } else {
                Write-Log -Level Error -Text "Failed to remove subkeys under '$Path' for user '$($profile.Username)'."
            }
        }
 
        # Unload the ntuser.dat hive if it was initially unloaded
        if ($profile.SID -in $unloadedHives.SID) {
            [gc]::Collect()
            reg unload HKU\$($profile.SID) | Out-Null
        }
    }
}
 
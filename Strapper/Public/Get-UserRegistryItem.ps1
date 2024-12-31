function Get-UserRegistryItem {
    <#
    .SYNOPSIS
        Retrieves a list of user-specific registry properties and their values.
 
    .EXAMPLE
        Get-UserRegistryItem -Path "SOFTWARE\_automation\Prompter"
        Retrieves all registry properties and their values for the specified path in each user's registry hive.
 
        Get-UserRegistryItem -Path "SOFTWARE\_automation\Prompter" -ChildItem
        Retrieves all registry properties and their values for the specified path and its immediate subkeys from each user's registry hive.
 
        Get-UserRegistryItem -Path "SOFTWARE\_automation\Prompter" -Recurse
        Retrieves all registry properties and their values for the specified path and all its subkeys recursively from each user's registry hive.
 
    .PARAMETER Path
        Specifies the relative registry path.
        Example: To retrieve properties under `HKEY_CURRENT_USER\SOFTWARE\7-Zip\Compression`, pass `"SOFTWARE\7-Zip\Compression"`.
 
    .PARAMETER ChildItem
        Retrieves registry properties and their values for the specified path and its immediate subkeys.
        Example: To retrieve properties under `HKEY_CURRENT_USER\SOFTWARE\7-Zip\Compression` and its direct subkeys, include `-ChildItem`.
 
    .PARAMETER Recurse
        Retrieves registry properties and their values for the specified path and all subkeys recursively.
        Example: To retrieve properties under `HKEY_CURRENT_USER\SOFTWARE\7-Zip\Compression` and all its subkeys, include `-Recurse`.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'ChildItem')]
        [Parameter(ParameterSetName = 'Recurse')]
        [Parameter(Mandatory)][string]$Path,
        [Parameter(ParameterSetName = 'ChildItem')]
        [Parameter(Mandatory = $false)][switch]$ChildItem,
        [Parameter(ParameterSetName = 'Recurse')]
        [Parameter(Mandatory = $false)][switch]$Recurse
    )
 
    # Ensure the platform is Windows before proceeding
    if ($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is supported only on Windows-based platforms.' -ErrorAction Stop
    }
    
    # Define the regular expression pattern to identify Security Identifiers (SIDs)
    $patternSID = '((S-1-5-21)|(S-1-12-1))-\d+-\d+\-\d+\-\d+$'
 
    # Retrieve information about all user profiles, including their SIDs and the location of their `ntuser.dat` files
    $profileList = Get-RegistryHivePath
 
    # Retrieve the SIDs of loaded user registry hives from HKEY_USERS
    $loadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object { $_.PSChildname -match $PatternSID } | Select-Object @{name = 'SID'; expression = { $_.PSChildName } }
 
    # Determine which user hives are not currently loaded
    if ($LoadedHives) {
        $UnloadedHives = Compare-Object $ProfileList.SID $LoadedHives.SID | Select-Object @{name = 'SID'; expression = { $_.InputObject } }, UserHive, Username
    } else {
        $UnloadedHives = $ProfileList
    }
 
    # Initialize the collection of registry entries
    $returnEntries = @(
        foreach ($profile in $ProfileList) {
            # Load the user's registry hive if it is not already loaded
            if ($profile.SID -in $UnloadedHives.SID) {
                reg load HKU\$($profile.SID) $($profile.UserHive) | Out-Null
            }
 
            # Construct the absolute registry path for the current user
            $registryPath = "Registry::HKEY_USERS\$($profile.SID)\$Path"
            $key = $($Path -split '\\')[-1]

            $entries = @()

            # Retrieve properties for the parent key
            $returnEntry = $null
            $returnEntry = Get-ItemProperty -Path $registryPath -ErrorAction SilentlyContinue

            # Create an object representing the registry properties
            if (Test-Path -Path $registryPath) {
                $entry = [PSCustomObject]@{
                    Username = $profile.Username
                    UserSID = $profile.SID
                    RegistryPath = $registryPath
                    ProfileHive = $profile.UserHive
                    RegistryKey = $key
                }
                if ($null -ne $returnEntry) {
                    $names = $returnEntry | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' -and $_.Name -notin ('PSPath', 'PSParentPath', 'PSProvider', 'PSChildName') } | Select-Object -ExpandProperty Name
                    foreach ($name in $names) {
                        $entry | Add-Member -MemberType NoteProperty -Name $name -Value $returnEntry.$name
                    }
                }
                $entries += $entry
            }

            # Retrieve registry entries for sub keys
            if ($Recurse -or $ChildItem) {
                $subKeys = Get-ChildItem -Path $registryPath -Recurse:$(if($Recurse.IsPresent){ $true } else { $false }) -ErrorAction SilentlyContinue | Select-Object -Property Name, PSChildName
                foreach ($key in $subKeys) {
                    # Construct the path for the current subkey
                    $subKeyPath = "Registry::\$($key.Name)"
                    $key = $key.PSChildName
 
                    # Retrieve properties for the current subkey
                    $returnEntry = $null
                    $returnEntry = Get-ItemProperty -Path $subKeyPath -ErrorAction SilentlyContinue
 
                    # Create an object representing the subkey and its properties
                    $entry = $null
                    $entry = [PSCustomObject]@{
                        Username = $profile.Username
                        UserSID = $profile.SID
                        RegistryPath = $subKeyPath
                        ProfileHive = $profile.UserHive
                        RegistryKey = $key
                    }
                    if ($null -ne $returnEntry) {
                        $names = $returnEntry | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' -and $_.Name -notin ('PSPath', 'PSParentPath', 'PSProvider', 'PSChildName') } | Select-Object -ExpandProperty Name
                        foreach ($name in $names) {
                            $entry | Add-Member -MemberType NoteProperty -Name $name -Value $returnEntry.$name
                        }
                    }
                    $entries += $entry
                }
            }
            $entries
            # Unload the user's registry hive if it was initially unloaded
            if ($profile.SID -in $UnloadedHives.SID) {
                [gc]::Collect()
                reg unload HKU\$($profile.SID) | Out-Null
            }
        }
    )
    return $returnEntries
}
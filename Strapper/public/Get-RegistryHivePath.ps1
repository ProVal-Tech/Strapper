function Get-RegistryHivePath {
    <#
    .SYNOPSIS
        Gets a list of registry hives from the local computer.
    .NOTES
        Bootstrap use only.
    .EXAMPLE
        Get-RegistryHivePath
        Returns the full list of registry hives.
    .PARAMETER ExcludeDefault
        Exclude the Default template hive from the return.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $false)][switch]$ExcludeDefault
    )
    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'This function is only supported on Windows-based platforms.' -ErrorAction Stop
    }
    # Regex pattern for SIDs
    $patternSID = '((S-1-5-21)|(S-1-12-1))-\d+-\d+\-\d+\-\d+$'

    # Get Username, SID, and location of ntuser.dat for all users
    $profileList = @(
        Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' | Where-Object { $_.PSChildName -match $PatternSID } |
            Select-Object @{name = 'SID'; expression = { $_.PSChildName } },
            @{name = 'UserHive'; expression = { "$($_.ProfileImagePath)\ntuser.dat" } },
            @{name = 'Username'; expression = { $_.ProfileImagePath -replace '^(.*[\\\/])', '' } }
    )

    # If the default user was not excluded, add it to the list of profiles to process.
    if (!$ExcludeDefault) {
        $profileList += [PSCustomObject]@{
            SID = 'DefaultUserTemplate'
            UserHive = "$env:SystemDrive\Users\Default\ntuser.dat"
            Username = 'DefaultUserTemplate'
        }
    }
    return $profileList
}
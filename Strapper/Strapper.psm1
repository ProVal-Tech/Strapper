#region StrapperSession
$StrapperSession = [pscustomobject]@{
    LogPath = $null
    DataPath = $null
    ErrorPath = $null
    WorkingPath = $null
    ScriptTitle = $null
    IsLoaded = $true
    IsElevated = $false
    Platform = [System.Environment]::OSVersion.Platform
}

if ($MyInvocation.PSCommandPath) {
    $scriptObject = Get-Item -Path $MyInvocation.PSCommandPath
    $StrapperSession.WorkingPath = $($scriptObject.DirectoryName)
    $StrapperSession.LogPath = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-log.txt"
    $StrapperSession.DataPath = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-data.txt"
    $StrapperSession.ErrorPath = Join-Path $StrapperSession.WorkingPath "$($scriptObject.BaseName)-error.txt"
    $StrapperSession.ScriptTitle = $scriptObject.BaseName
} else {
    $StrapperSession.WorkingPath = (Get-Location).Path
    $StrapperSession.LogPath = Join-Path $StrapperSession.WorkingPath "$((Get-Date).ToString('yyyyMMdd'))-log.txt"
    $StrapperSession.DataPath = Join-Path $StrapperSession.WorkingPath "$((Get-Date).ToString('yyyyMMdd'))-data.txt"
    $StrapperSession.ErrorPath = Join-Path $StrapperSession.WorkingPath "$((Get-Date).ToString('yyyyMMdd'))-error.txt"
    $StrapperSession.ScriptTitle = '***Manual Run***'
}

if ($StrapperSession.Platform -eq 'Win32NT') {
    $StrapperSession.IsElevated = (New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
} else {
    $StrapperSession.IsElevated = $(id -u) -eq 0
}
#endregion

#region Private Functions
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

function Write-InformationExtended {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][Object]$MessageData,
        [System.ConsoleColor]$ForegroundColor = $Host.UI.RawUI.ForegroundColor,
        [System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor,
        [switch]$NoNewLine
    )

    $message = [System.Management.Automation.HostInformationMessage]@{
        Message = $MessageData
        ForegroundColor = $ForegroundColor
        BackgroundColor = $BackgroundColor
        NoNewLine = $NoNewLine.IsPresent
    }

    Write-Information -MessageData $message
}

function Write-LogHelper {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'String')]
        [AllowEmptyString()]
        [string]$Text,
        [Parameter(Mandatory = $true, ParameterSetName = 'String')]
        [string]$Type
    )
    $formattedLog = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))  $($Type.PadRight(8)) $Text"
    switch ($Type) {
        'LOG' {
            Write-InformationExtended -MessageData $formattedLog
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'INIT' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor DarkBlue
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'WARN' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor Black -BackgroundColor DarkYellow
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'ERROR' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor DarkRed
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
            Add-Content -Path $StrapperSession.errorPath -Value $formattedLog
        }
        'SUCCESS' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor DarkGreen
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'DATA' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor Blue
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
            Add-Content -Path $StrapperSession.dataPath -Value $Text
        }
        Default {
            Write-InformationExtended -MessageData $formattedLog
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
    }
}
#endregion

#region Public Functions
function Set-StrapperEnviornment {
    Remove-Item -Path $StrapperSession.DataPath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $StrapperSession.ErrorPath -Force -ErrorAction SilentlyContinue
    Write-Log -Text '-----------------------------------------------' -Type INIT
    Write-Log -Text $StrapperSession.ScriptTitle -Type INIT
    Write-Log -Text "System: $([Environment]::MachineName)" -Type INIT
    Write-Log -Text "User: $([Environment]::UserName)" -Type INIT
    Write-Log -Text "OS Bitness: $((32,64)[[Environment]::Is64BitOperatingSystem])" -Type INIT
    Write-Log -Text "PowerShell Bitness: $(if([Environment]::Is64BitProcess) {64} else {32})" -Type INIT
    Write-Log -Text "PowerShell Version: $(Get-Host | Select-Object -ExpandProperty Version | Select-Object -ExpandProperty Major)" -Type INIT
    Write-Log -Text '-----------------------------------------------' -Type INIT
}

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

function Get-StrapperWorkingPath {
    return $StrapperSession.WorkingPath
}

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
            if ($returnEntry) {
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

function Install-Chocolatey {
    <#
    .SYNOPSIS
        Installs or updates the Chocolatey package manager.
    .EXAMPLE
        PS C:\> Install-Chocolatey
    #>
    if($StrapperSession.Platform -ne 'Win32NT') {
        Write-Error 'Chocolatey is only supported on Windows-based platforms. Use your better package manager instead. ;)' -ErrorAction Stop
    }
    if ($env:path -split ';' -notcontains ";$($env:ALLUSERSPROFILE)\chocolatey\bin") {
        $env:Path = $env:Path + ";$($env:ALLUSERSPROFILE)\chocolatey\bin"
    }
    if (Test-Path -Path "$($env:ALLUSERSPROFILE)\chocolatey\bin") {
        Write-Log -Text 'Chocolatey installation detected.' -Type LOG
        choco upgrade chocolatey -y | Out-Null
        choco feature enable -n=allowGlobalConfirmation -confirm | Out-Null
        choco feature disable -n=showNonElevatedWarnings -confirm | Out-Null
        return 0
    } else {
        [Net.ServicePointManager]::SecurityProtocol = [Enum]::ToObject([Net.SecurityProtocolType], 3072)
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        choco feature enable -n=allowGlobalConfirmation -confirm | Out-Null
        choco feature disable -n=showNonElevatedWarnings -confirm | Out-Null
    }

    if (!(Test-Path -Path "$($env:ALLUSERSPROFILE)\chocolatey\bin")) {
        Write-Log -Text 'Chocolatey installation failed.' -Type ERROR
        return 1
    }
    return 0
}

function Install-GitHubModule {
    <#
    .SYNOPSIS
        Install a PowerShell module from a GitHub repository.
    .DESCRIPTION
        Install a PowerShell module from a GitHub repository via PowerShellGet v3.

        This script requires a separate Azure function that returns a GitHub Personal Access Token based on two Base64 encoded scripts passed to it.
    .PARAMETER Name
        The name of the Github module to install.
    .PARAMETER Username
        The username of the Github user to authenticate with.
    .PARAMETER GithubPackageUri
        The URI to the Github Nuget package repository.
    .PARAMETER AzureGithubPATUri
        The URI to the Azure function that will return the PAT.
    .PARAMETER AzureGithubPATFunctionKey
        The function key for the Azure function.
    .EXAMPLE
        Install-GitHubModule `
            -Name MyGithubModule `
            -Username GithubUser `
            -GitHubPackageUri 'https://nuget.pkg.github.com/GithubUser/index.json' `
            -AzureGithubPATUri 'https://pat-function-subdomain.azurewebsites.net/api/FunctionName' `
            -AzureGithubPATFunctionKey 'MyFunctionKey'
        Import-Module -Name MyGithubModule
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Username,
        [Parameter(Mandatory)][string]$GithubPackageUri,
        [Parameter(Mandatory)][string]$AzureGithubPATUri,
        [Parameter(Mandatory)][string]$AzureGithubPATFunctionKey
    )
    Write-Debug -Message "--- Parameters ---"
    Write-Debug -Message "Name: $Name"
    Write-Debug -Message "GitHub Username: $Username"
    Write-Debug -Message "GitHub Package Uri: $GithubPackageUri"
    Write-Debug -Message "Azure Function Uri: $AzureGithubPATUri"
    Write-Debug -Message "Azure Function Key: $AzureGithubPATFunctionKey"
    
    # Install PowerShellGet v3+ if not already installed.
    Write-Debug -Message "Checking for PowerShellGet v3+"
    if (!(Get-Module -ListAvailable -Name PowerShellGet | Where-Object { $_.Version.Major -ge 3 })) {
        Write-Debug -Message "Installing PowerShellGet v3+"
        Install-Module -Name PowerShellGet -AllowPrerelease -Force
    }

    # Get 'Strapper.psm1' path and encode to Base64
    $moduleMemberPath = (Get-ChildItem (Get-Item (Get-Module -name Strapper).Path).Directory -Recurse -Filter "Strapper.psm1" -File).FullName
    Write-Debug -Message "Encoding '$moduleMemberPath' content as Base64 string."
    $base64EncodedModuleMember = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes((Get-Content -LiteralPath $moduleMemberPath -Raw)))
    Write-Debug -Message "Encoded $moduleMemberPath`: $base64EncodedModuleMember"

    # Encode the calling script to Base64
    Write-Debug -Message "Encoding $($MyInvocation.PSCommandPath) as Base64 string."
    $base64EncodedScript = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes((Get-Content -LiteralPath $($MyInvocation.PSCommandPath) -Raw)))
    Write-Debug -Message "Encoded $($MyInvocation.PSCommandPath)`: $base64EncodedScript"

    Write-Debug -Message "Registering '$GithubPackageUri' as temporary repo."
    Register-PSResourceRepository -Name TempGithub -Uri $GithubPackageUri -Trusted
    Write-Debug -Message "Acquiring GitHub PAT"
    $githubPAT = (
        Invoke-RestMethod `
            -Uri "$($AzureGithubPATUri)?code=$($AzureGithubPATFunctionKey)" `
            -Method Post `
            -Body $(
                @{
                    Script = $base64EncodedScript
                    ScriptExtension = [System.IO.FileInfo]::new($($MyInvocation.PSCommandPath)).Extension
                    ModuleMember = $base64EncodedModuleMember
                    ModuleMemberExtension = [System.IO.FileInfo]::new($moduleMemberPath).Extension
                } | ConvertTo-Json
            ) `
            -ContentType 'application/json'
    ) | ConvertTo-SecureString -AsPlainText -Force
    Write-Debug -Message "PAT Last 4: $(([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($githubPAT)))[-4..-1])"
    Write-Debug -Message "Installing module '$Name'."

    Install-PSResource -Name $Name -Repository TempGithub -Credential (New-Object System.Management.Automation.PSCredential($Username, $githubPAT))
    Write-Debug -Message "Unregistering '$GithubPackageUri'."
    Unregister-PSResourceRepository -Name TempGithub
}

function Publish-GitHubModule {
    <#
    .SYNOPSIS
        Publish a PowerShell module to a GitHub repository.
    .PARAMETER Path
        The path to the psd1 file for the module to publish.
    .PARAMETER Token
        The Github personal access token to use for publishing.
    .PARAMETER RepoUri
        The URI to the GitHub repo to publish to.
    .PARAMETER TempNugetPath
        The path to use to make a temporary NuGet repo.
    .EXAMPLE
        Publish-GitHubModule `
            -Path 'C:\users\user\Modules\MyModule\MyModule.psd1' `
            -Token 'ghp_abcdefg1234567' `
            -RepoUri 'https://github.com/user/MyModule'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Token,
        [Parameter(Mandatory)][string]$RepoUri,
        [Parameter()][string]$TempNugetPath = "$env:SystemDrive\temp\nuget\publish"
    )
    if (!(Get-Module -ListAvailable -Name PowerShellGet | Where-Object { $_.Version.Major -ge 3 })) {
        Install-Module -Name PowerShellGet -AllowPrerelease -Force
    }
    $targetModule = Get-Module $Path -ListAvailable
    if(!$targetModule) {
        Write-Error -Message "Failed to locate a module with the path '$targetModule'. Please pass a path to a .psd1 and try again."
        return
    }
    if(!(Test-Path -Path $TempNugetPath)) {
        New-Item -Path $TempNugetPath -ItemType Directory
    }
    Register-PSResourceRepository -Name TempNuget -Uri $TempNugetPath
    Publish-PSResource -Path $targetModule.ModuleBase -Repository TempNuget
    if(!((dotnet tool list --global) | Select-String "^gpr.*gpr.*$")) {
        dotnet tool install --global gpr
    }
    gpr push -k $Token "$TempNugetPath\$($targetModule.Name).$($targetModule.Version).nupkg" -r $RepoUri
    Unregister-PSResourceRepository -Name TempNuget
}

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
            Write-Log -Text "The requested registry entry for user '$($profile.Username)' does not exist." -Type LOG
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
            Write-Log -Text "Removed the requested registry entry for user '$($profile.Username)'" -Type LOG
        } else {
            Write-Log -Text "Failed to remove the requested registry entry for user '$($profile.Username)'" -Type ERROR
        }

        # Collect garbage and close ntuser.dat if the hive was initially unloaded
        if ($profile.SID -in $UnloadedHives.SID) {
            [gc]::Collect()
            reg unload HKU\$($profile.SID) | Out-Null
        }
    }
}

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

function Write-Log {
    <#
    .SYNOPSIS
        Writes a message to a log file, the console, or both.
    .EXAMPLE
        PS C:\> Write-Log -Text "An error occurred." -Type ERROR
        This will write an error to the console, the log file, and the error log file.
    .PARAMETER Text
        The message to pass to the log.
    .PARAMETER StringArray
        An array of strings to write to the log.
    .PARAMETER Type
        The type of log message to pass in. The options are:
        LOG     - Outputs to the log file and console.
        WARN    - Outputs to the log file and console.
        ERROR   - Outputs to the log file, error file, and console.
        SUCCESS - Outputs to the log file and console.
        DATA    - Outputs to the log file, data file, and console.
        INIT    - Outputs to the log file and console.
        Default (Any other string) - Outputs to the log file and console.
    .NOTES
        If this function is run on the console then it will output a log file to the current directory in the format YYYYMMDD-log/data/error.txt
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'String')]
        [AllowEmptyString()][Alias('Message')]
        [string]$Text,
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'StringArray')]
        [AllowEmptyString()]
        [string[]]$StringArray,
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'String')]
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'StringArray')]
        [string]$Type = 'LOG'
    )
    if (!($StrapperSession.logPath -and $StrapperSession.dataPath -and $StrapperSession.errorPath)) {
        $location = (Get-Location).Path
        $StrapperSession.logPath = Join-Path $location "$((Get-Date).ToString('yyyyMMdd'))-log.txt"
        $StrapperSession.dataPath = Join-Path $location "$((Get-Date).ToString('yyyyMMdd'))-data.txt"
        $StrapperSession.errorPath = Join-Path $location "$((Get-Date).ToString('yyyyMMdd'))-error.txt"
    }
    #Optimize-Content -Path $script:logPath
    if ($StringArray) {
        foreach ($logItem in $StringArray) {
            Write-LogHelper -Text $logItem -Type $Type
        }
    } elseif ($Text) {
        Write-LogHelper -Text $Text -Type $Type
    }
}
#endregion

Export-ModuleMember -Variable StrapperSession

# SIG # Begin signature block
# MIInbwYJKoZIhvcNAQcCoIInYDCCJ1wCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCsvnv/9QnxIeeW
# kpiRrjgqovSglFWemBq7NomeNwMjwqCCILYwggXYMIIEwKADAgECAhEA5CcElfaM
# kdbQ7HtJTqTfHDANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJQTDEiMCAGA1UE
# ChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEnMCUGA1UECxMeQ2VydHVtIENl
# cnRpZmljYXRpb24gQXV0aG9yaXR5MSIwIAYDVQQDExlDZXJ0dW0gVHJ1c3RlZCBO
# ZXR3b3JrIENBMB4XDTE4MDkxMTA5MjY0N1oXDTIzMDkxMTA5MjY0N1owfDELMAkG
# A1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMRAwDgYDVQQHDAdIb3VzdG9uMRgwFgYD
# VQQKDA9TU0wgQ29ycG9yYXRpb24xMTAvBgNVBAMMKFNTTC5jb20gUm9vdCBDZXJ0
# aWZpY2F0aW9uIEF1dGhvcml0eSBSU0EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQD5D92jK33L0Cr+7GeFpucuG7p34eP1r6Ts+kpdkcRXR2sYd2t28v2T
# 5D0PwhaeC2bDVpSeF4OFzlbv8hb9AGL1IglU6GUXTkG54E9Gl6obyLhuYl5psV/b
# KgJ+/GzK80HY7dDo/D9hSO2wAxQdEA5LGeC7TuyGZf82815nAgudhlVh/Xo47f7i
# GQC3b6FQYnV0PKD6yCWStG56Isf4HqHjst2RMasrHQT/pUoEN+mFpDMr/eLWVTR8
# GaRKaMeyqNO3yqGTiOvBl7yM+R3ZIoQkdMcEPWqpKZPM67hb4f5fJao0WMjBI1Sd
# G5gRwzicfj2GbKUPQIZ8AvRcAk8oy65xnw86yDP+ESU16vy6xWA92XwY1bKp03V4
# A3IiyjrDH+8s5S6p+p4stlFG/a8D1upgaOqFFjZrhekewLPdxCTcgCqBQW2UPsjg
# yYFBAJ5ev3/FCJiiGCxCQLP5bzgnS06A9D2BR+CIfOoczrV1XFEuHCt/GnIo5wC1
# 0XTG1+SfrQeTtlM1Nfw35MP2XRa+IXPekgr4oGNqvJaSaj74vGVVm971DYkmBPwl
# GqYlacvCbcp84llfl6zr7y7IvNcbWTwrzPIZyJNrJ2MZz/zpJvjKcZt/k/40Z4RO
# mev8s3gJM3C6ZqZ27Rtz6xqlDcQiEyCUVgpOLGxOsf3PnAm6ojPthwIDAQABo4IB
# UTCCAU0wEgYDVR0TAQH/BAgwBgEB/wIBAjAdBgNVHQ4EFgQU3QQJB6L1en1SUxKS
# le44gCUNplkwHwYDVR0jBBgwFoAUCHbNywf/JPbFze27kLzihDdGdfcwDgYDVR0P
# AQH/BAQDAgEGMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9zc2xjb20uY3JsLmNl
# cnR1bS5wbC9jdG5jYS5jcmwwcwYIKwYBBQUHAQEEZzBlMCkGCCsGAQUFBzABhh1o
# dHRwOi8vc3NsY29tLm9jc3AtY2VydHVtLmNvbTA4BggrBgEFBQcwAoYsaHR0cDov
# L3NzbGNvbS5yZXBvc2l0b3J5LmNlcnR1bS5wbC9jdG5jYS5jZXIwOgYDVR0gBDMw
# MTAvBgRVHSAAMCcwJQYIKwYBBQUHAgEWGWh0dHBzOi8vd3d3LmNlcnR1bS5wbC9D
# UFMwDQYJKoZIhvcNAQELBQADggEBAB+VmiNU7oXC89RvuekEj0Z/LPcywKdDrAcA
# 7eCpRS39F+HtAEDIr5is9cAZrRuglzBAbOxb+6OTToyJYht88Dpfp0LPWMp1ZZwi
# TL92e5iTnBWDM7EO3FE4h3yVnBJplB4AeHR+3MAGd7pwLYcs12id47qFrUnzj2S0
# FQaDksaXpECTi63xZ5S0uVpnVDyoG9kFz+Sk+YgSAAaIJYXUXu7zk1fWgfgsrvf1
# UUirtmI6edvsLvI/FFY6yNnLpKJPJajRm6stMCBQBxpv8fGUHTmDY+gf/UnQ6B1G
# skaCJr2cneGiaEFIUW56/DWW9FTSvCtE5UfXd4KlSqtflzOrJBEwggZyMIIEWqAD
# AgECAghkM1HTxzifCDANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzEOMAwG
# A1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xGDAWBgNVBAoMD1NTTCBDb3Jw
# b3JhdGlvbjExMC8GA1UEAwwoU1NMLmNvbSBSb290IENlcnRpZmljYXRpb24gQXV0
# aG9yaXR5IFJTQTAeFw0xNjA2MjQyMDQ0MzBaFw0zMTA2MjQyMDQ0MzBaMHgxCzAJ
# BgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
# A1UECgwIU1NMIENvcnAxNDAyBgNVBAMMK1NTTC5jb20gQ29kZSBTaWduaW5nIElu
# dGVybWVkaWF0ZSBDQSBSU0EgUjEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCfgxNzqrDGbSHL24t6h3TQcdyOl3Ka5LuINLTdgAPGL0WkdJq/Hg9Q6p5t
# ePOf+lEmqT2d0bKUVz77OYkbkStW72fL5gvjDjmMxjX0jD3dJekBrBdCfVgWQNz5
# 1ShEHZVkMGE6ZPKX13NMfXsjAm3zdetVPW+qLcSvvnSsXf5qtvzqXHnpD0OctVIF
# D+8+sbGP0EmtpuNCGVQ/8y8Ooct8/hP5IznaJRy4PgBKOm8yMDdkHseudQfYVdIY
# yQ6KvKNc8HwKp4WBwg6vj5lc02AlvINaaRwlE81y9eucgJvcLGfE3ckJmNVz68Qh
# o+Uyjj4vUpjGYDdkjLJvSlRyGMwnh/rNdaJjIUy1PWT9K6abVa8mTGC0uVz+q0O9
# rdATZlAfC9KJpv/XgAbxwxECMzNhF/dWH44vO2jnFfF3VkopngPawismYTJboFbl
# SSmNNqf1x1KiVgMgLzh4gL32Bq5BNMuURb2bx4kYHwu6/6muakCZE93vUN8BuvIE
# 1tAx3zQ4XldbyDgeVtSsSKbt//m4wTvtwiS+RGCnd83VPZhZtEPqqmB9zcLlL/Hr
# 9dQg1Zc0bl0EawUR0tOSjAknRO1PNTFGfnQZBWLsiePqI3CY5NEv1IoTGEaTZeVY
# c9NMPSd6Ij/D+KNVt/nmh4LsRR7Fbjp8sU65q2j3m2PVkUG8qQIDAQABo4H7MIH4
# MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU3QQJB6L1en1SUxKSle44gCUN
# plkwMAYIKwYBBQUHAQEEJDAiMCAGCCsGAQUFBzABhhRodHRwOi8vb2NzcHMuc3Ns
# LmNvbTARBgNVHSAECjAIMAYGBFUdIAAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwOwYD
# VR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNvbS9zc2wuY29tLXJzYS1S
# b290Q0EuY3JsMB0GA1UdDgQWBBRUwv4QlQCTzWr158DX2bJLuI8M4zAOBgNVHQ8B
# Af8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAPUPJodwr5miyvXWyfCNZj05gtOI
# I9iCv49UhCe204MH154niU2EjlTRIO5gQ9tXQjzHsJX2vszqoz2OTwbGK1mGf+tz
# G8rlQCbgPW/M9r1xxs19DiBAOdYF0q+UCL9/wlG3K7V7gyHwY9rlnOFpLnUdTsth
# HvWlM98CnRXZ7WmTV7pGRS6AvGW+5xI+3kf/kJwQrfZWsqTU+tb8LryXIbN2g9KR
# +gZQ0bGAKID+260PZ+34fdzZcFt6umi1s0pmF4/n8OdX3Wn+vF7h1YyfE7uVmhX7
# eSuF1W0+Z0duGwdc+1RFDxYRLhHDsLy1bhwzV5Qe/kI0Ro4xUE7bM1eV+jjk5hLb
# q1guRbfZIsr0WkdJLCjoT4xCPGRo6eZDrBmRqccTgl/8cQo3t51Qezxd96JSgjXk
# tefTCm9r/o35pNfVHUvnfWII+NnXrJlJ27WEQRQu9i5gl1NLmv7xiHp0up516eDa
# p8nMLDt7TAp4z5T3NmC2gzyKVMtODWgqlBF1JhTqIDfM63kXdlV4cW3iSTgzN9vk
# bFnHI2LmvM4uVEv9XgMqyN0eS3FE0HU+MWJliymm7STheh2ENH+kF3y0rH0/NVjL
# w78a3Z9UVm1F5VPziIorMaPKPlDRADTsJwjDZ8Zc6Gi/zy4WZbg8Zv87spWrmo2d
# zJTw7XhQf+xkR6OdMIIGdjCCBF6gAwIBAgIQeVwkxuz4snsBAPX7/vbayDANBgkq
# hkiG9w0BAQsFADB4MQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNV
# BAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBDb3JwMTQwMgYDVQQDDCtTU0wuY29t
# IENvZGUgU2lnbmluZyBJbnRlcm1lZGlhdGUgQ0EgUlNBIFIxMB4XDTIyMDkwODE4
# MTExNloXDTIzMDkwNzE4MTExNlowfzELMAkGA1UEBhMCVVMxEDAOBgNVBAgMB0Zs
# b3JpZGExGjAYBgNVBAcMEUFsdGFtb250ZSBTcHJpbmdzMSAwHgYDVQQKDBdQcm92
# YWwgVGVjaG5vbG9naWVzIEluYzEgMB4GA1UEAwwXUHJvdmFsIFRlY2hub2xvZ2ll
# cyBJbmMwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQC8rFgT0frNYMOu
# jhP3zY5GLj2hndjE1m5UiIUtUXJ0N/X+U7ZzplXEAOrEifqApdBlTrCicq4G5qwk
# 8UV6q0gU6tDxiL8IUHNf6716MTLZuTr08gdLWY6t75Pi8JYz9FtgyiMNB8mo22MY
# 9DpBrW+uNCEO7hZP/siq+rRgroeyn8ClmKrlEvNXHIprqkaE/jBgmVWai3OrwMfK
# 7G7o0MMBAgIoIzyHBWD4nB4Bk66IbAyY6C3ORwBrpgzfT51+/yv2aEKbuZllTRRx
# pjFohqC02BYNrltAnypTO7lWdTWyfl/aTyY93kubWVJMrw5V7aQkbjtZuJUMO3uY
# DmDc8bw3kRYfT/ygA4RZBGkwWNrwOUR2XgOFjK4374jzpa/JW6TaU/v9espLB7RL
# YoUwKONPyMTEE5cBJOK91IwBeoeib0SSYadvtC2VxhaViB12il3mgOxP14o/ckRL
# 4sL3oiABqpYsPgBK0tq6We+JVyX+9GF2Gkje3Gc4jO+1s/B3cNECAwEAAaOCAXMw
# ggFvMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUVML+EJUAk81q9efA19myS7iP
# DOMwWAYIKwYBBQUHAQEETDBKMEgGCCsGAQUFBzAChjxodHRwOi8vY2VydC5zc2wu
# Y29tL1NTTGNvbS1TdWJDQS1Db2RlU2lnbmluZy1SU0EtNDA5Ni1SMS5jZXIwUQYD
# VR0gBEowSDAIBgZngQwBBAEwPAYMKwYBBAGCqTABAwMBMCwwKgYIKwYBBQUHAgEW
# Hmh0dHBzOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeTATBgNVHSUEDDAKBggrBgEF
# BQcDAzBNBgNVHR8ERjBEMEKgQKA+hjxodHRwOi8vY3Jscy5zc2wuY29tL1NTTGNv
# bS1TdWJDQS1Db2RlU2lnbmluZy1SU0EtNDA5Ni1SMS5jcmwwHQYDVR0OBBYEFOAY
# zCQ+hpcdCmsNYDdqF4DvoC5DMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsF
# AAOCAgEASHm1T/O4wAemUn5bAfQSnWz4raO9XPSwWytQqjMadSyCTqnz/uO37+dd
# sYBnla323Abl/7zV73Tg2dYDy4yM9W9MxL9Z3aylngcRI7cz4A/262ny2pRrjY3Y
# NSNeM1q4eGBXsMb2bqKVE1dZ9g9qSk+LpLOpExEpH4mvZjjjrUL0kQhlvytSDWpI
# QiZgIYI7JFW7TUXCdNtjnRLhqIJ08sfygk4tduO10XRC4NpxXeZEeqoU8EpW8Jfr
# IRH5zg/rWVygCltSHLkVaGk0jpWrLZCDmquG9CohhNdAPG2PMhZdAlijafyeg5YH
# zvK56qmWZvGemVbRK/TOXCh8UZNK3DjDT8ouylTe1Y0rG6Ml9yX7rBHaOu3seiiJ
# 5o/mWfse8KR57nQ584kkL3qACm9WV2WmVPRQKWeziv9CsQzilVKMshBlQDqNYIAf
# oIaIduQjQoXjmNN00x6IL3cvlzOlRUaw+Pj/BTttjcs+x6mbHCd0VuJPb+92SbRS
# wDSAnqeWcxTwPY50U3zaaw3SgH/ZWeXfRXC5KJ8Pd7Mq4+0wbpqodzGarlZc8Z+8
# AkaHruRrhYFD05+Cr23/h9gl67G3xaY2mrweqlLY8c+J6BqP4mR4vWq11YajIIZQ
# AG6XcWbVznjn//R5cOeiUz037bI9Wjj91JXf45BE4dqvukgTWcUwggbsMIIE1KAD
# AgECAhAwD2+s3WaYdHypRjaneC25MA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkx
# HjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRy
# dXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xOTA1MDIwMDAwMDBa
# Fw0zODAxMTgyMzU5NTlaMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
# IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28g
# TGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMgbAa/ZLH6ImX0BmD8gkL2c
# gCFUk7nPoD5T77NawHbWGgSlzkeDtevEzEk0y/NFZbn5p2QWJgn71TJSeS7JY8IT
# m7aGPwEFkmZvIavVcRB5h/RGKs3EWsnb111JTXJWD9zJ41OYOioe/M5YSdO/8zm7
# uaQjQqzQFcN/nqJc1zjxFrJw06PE37PFcqwuCnf8DZRSt/wflXMkPQEovA8NT7OR
# AY5unSd1VdEXOzQhe5cBlK9/gM/REQpXhMl/VuC9RpyCvpSdv7QgsGB+uE31DT/b
# 0OqFjIpWcdEtlEzIjDzTFKKcvSb/01Mgx2Bpm1gKVPQF5/0xrPnIhRfHuCkZpCkv
# RuPd25Ffnz82Pg4wZytGtzWvlr7aTGDMqLufDRTUGMQwmHSCIc9iVrUhcxIe/arK
# CFiHd6QV6xlV/9A5VC0m7kUaOm/N14Tw1/AoxU9kgwLU++Le8bwCKPRt2ieKBtKW
# h97oaw7wW33pdmmTIBxKlyx3GSuTlZicl57rjsF4VsZEJd8GEpoGLZ8DXv2DolNn
# yrH6jaFkyYiSWcuoRsDJ8qb/fVfbEnb6ikEk1Bv8cqUUotStQxykSYtBORQDHin6
# G6UirqXDTYLQjdprt9v3GEBXc/Bxo/tKfUU2wfeNgvq5yQ1TgH36tjlYMu9vGFCJ
# 10+dM70atZ2h3pVBeqeDAgMBAAGjggFaMIIBVjAfBgNVHSMEGDAWgBRTeb9aqitK
# z1SA4dibwJ3ysgNmyzAdBgNVHQ4EFgQUGqH4YRkgD8NBd0UojtE1XwYSBFUwDgYD
# VR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYB
# BQUHAwgwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6
# Ly9jcmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5LmNybDB2BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9j
# cnQudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggr
# BgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwF
# AAOCAgEAbVSBpTNdFuG1U4GRdd8DejILLSWEEbKw2yp9KgX1vDsn9FqguUlZkCls
# Ycu1UNviffmfAO9Aw63T4uRW+VhBz/FC5RB9/7B0H4/GXAn5M17qoBwmWFzztBEP
# 1dXD4rzVWHi/SHbhRGdtj7BDEA+N5Pk4Yr8TAcWFo0zFzLJTMJWk1vSWVgi4zVx/
# AZa+clJqO0I3fBZ4OZOTlJux3LJtQW1nzclvkD1/RXLBGyPWwlWEZuSzxWYG9vPW
# S16toytCiiGS/qhvWiVwYoFzY16gu9jc10rTPa+DBjgSHSSHLeT8AtY+dwS8BDa1
# 53fLnC6NIxi5o8JHHfBd1qFzVwVomqfJN2Udvuq82EKDQwWli6YJ/9GhlKZOqj0J
# 9QVst9JkWtgqIsJLnfE5XkzeSD2bNJaaCV+O/fexUpHOP4n2HKG1qXUfcb9bQ11l
# PVCBbqvw0NP8srMftpmWJvQ8eYtcZMzN7iea5aDADHKHwW5NWtMe6vBE5jJvHOsX
# TpTDeGUgOw9Bqh/poUGd/rG4oGUqNODeqPk85sEwu8CgYyz8XBYAqNDEf+oRnR4G
# xqZtMl20OAkrSQeq/eww2vGnL8+3/frQo4TZJ577AWZ3uVYQ4SBuxq6x+ba6yDVd
# M3aO8XwgDCp3rrWiAoa6Ke60WgCxjKvj+QrJVF3UuWp0nr1Irpgwggb2MIIE3qAD
# AgECAhEAkDl/mtJKOhPyvZFfCDipQzANBgkqhkiG9w0BAQwFADB9MQswCQYDVQQG
# EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
# b3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28g
# UlNBIFRpbWUgU3RhbXBpbmcgQ0EwHhcNMjIwNTExMDAwMDAwWhcNMzMwODEwMjM1
# OTU5WjBqMQswCQYDVQQGEwJHQjETMBEGA1UECBMKTWFuY2hlc3RlcjEYMBYGA1UE
# ChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDDCNTZWN0aWdvIFJTQSBUaW1lIFN0
# YW1waW5nIFNpZ25lciAjMzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AJCycT954dS5ihfMw5fCkJRy7Vo6bwFDf3NaKJ8kfKA1QAb6lK8KoYO2E+RLFQZe
# aoogNHF7uyWtP1sKpB8vbH0uYVHQjFk3PqZd8R5dgLbYH2DjzRJqiB/G/hjLk0NW
# esfOA9YAZChWIrFLGdLwlslEHzldnLCW7VpJjX5y5ENrf8mgP2xKrdUAT70KuIPF
# vZgsB3YBcEXew/BCaer/JswDRB8WKOFqdLacRfq2Os6U0R+9jGWq/fzDPOgNnDhm
# 1fx9HptZjJFaQldVUBYNS3Ry7qAqMfwmAjT5ZBtZ/eM61Oi4QSl0AT8N4BN3KxE8
# +z3N0Ofhl1tV9yoDbdXNYtrOnB786nB95n1LaM5aKWHToFwls6UnaKNY/fUta8pf
# ZMdrKAzarHhB3pLvD8Xsq98tbxpUUWwzs41ZYOff6Bcio3lBYs/8e/OS2q7gPE8P
# Wsxu3x+8Iq+3OBCaNKcL//4dXqTz7hY4Kz+sdpRBnWQd+oD9AOH++DrUw167aU1y
# meXxMi1R+mGtTeomjm38qUiYPvJGDWmxt270BdtBBcYYwFDk+K3+rGNhR5G8RrVG
# U2zF9OGGJ5OEOWx14B0MelmLLsv0ZCxCR/RUWIU35cdpp9Ili5a/xq3gvbE39x/f
# Qnuq6xzp6z1a3fjSkNVJmjodgxpXfxwBws4cfcz7lhXFAgMBAAGjggGCMIIBfjAf
# BgNVHSMEGDAWgBQaofhhGSAPw0F3RSiO0TVfBhIEVTAdBgNVHQ4EFgQUJS5oPGua
# KyQUqR+i3yY6zxSm8eAwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAwFgYD
# VR0lAQH/BAwwCgYIKwYBBQUHAwgwSgYDVR0gBEMwQTA1BgwrBgEEAbIxAQIBAwgw
# JTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdvLmNvbS9DUFMwCAYGZ4EMAQQC
# MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
# b1JTQVRpbWVTdGFtcGluZ0NBLmNybDB0BggrBgEFBQcBAQRoMGYwPwYIKwYBBQUH
# MAKGM2h0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1JTQVRpbWVTdGFtcGlu
# Z0NBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJ
# KoZIhvcNAQEMBQADggIBAHPa7Whyy8K5QKExu7QDoy0UeyTntFsVfajp/a3Rkg18
# PTagadnzmjDarGnWdFckP34PPNn1w3klbCbojWiTzvF3iTl/qAQF2jTDFOqfCFSr
# /8R+lmwr05TrtGzgRU0ssvc7O1q1wfvXiXVtmHJy9vcHKPPTstDrGb4VLHjvzUWg
# AOT4BHa7V8WQvndUkHSeC09NxKoTj5evATUry5sReOny+YkEPE7jghJi67REDHVB
# wg80uIidyCLxE2rbGC9ueK3EBbTohAiTB/l9g/5omDTkd+WxzoyUbNsDbSgFR36b
# LvBk+9ukAzEQfBr7PBmA0QtwuVVfR745ZM632iNUMuNGsjLY0imGyRVdgJWvAvu0
# 0S6dOHw14A8c7RtHSJwialWC2fK6CGUD5fEp80iKCQFMpnnyorYamZTrlyjhvn0b
# oXztVoCm9CIzkOSEU/wq+sCnl6jqtY16zuTgS6Ezqwt2oNVpFreOZr9f+h/EqH+n
# oUgUkQ2C/L1Nme3J5mw2/ndDmbhpLXxhL+2jsEn+W75pJJH/k/xXaZJL2QU/bYZy
# 06LQwGTSOkLBGgP70O2aIbg/r6ayUVTVTMXKHxKNV8Y57Vz/7J8mdq1kZmfoqjDg
# 0q23fbFqQSduA4qjdOCKCYJuv+P2t7yeCykYaIGhnD9uFllLFAkJmuauv2AV3Yb1
# MYIGDzCCBgsCAQEwgYwweDELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMRAw
# DgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE0MDIGA1UEAwwrU1NM
# LmNvbSBDb2RlIFNpZ25pbmcgSW50ZXJtZWRpYXRlIENBIFJTQSBSMQIQeVwkxuz4
# snsBAPX7/vbayDANBglghkgBZQMEAgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKAC
# gAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsx
# DjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCBSP7m99fHxc2QBpmz6Murp
# 7u/3wNhkrVrxFoFhJ2IPhzANBgkqhkiG9w0BAQEFAASCAYCi0LGl8Z0JWrfrOrpM
# gpUewBLpNFbo3q5D97vFcvapxgWEBo4fVDHmY1WzPgRQMn0CalULZpA4lxEyoiyC
# k1rpnArJ+pQGr3UJDcPN07d2AtjbUWyeM12m2WnFZqgQ6JqunzNx9mu2pee+F2KX
# zZXVDpzfaRaKq3LtF+f4km6vnW3dqyhJ+2e+ihCRWigcYFN4VKC1v7aRCeEM2D8C
# mjY+/Mn+4CRwJ033gFfix7Ml9EGgm9to70KbkOv89vMrvvpY2/9IFCYWlYyIyY9r
# 8F/K+vGp+PZFp4O6SykStugAbCnvDJC3IPXE4PcPIwKRNLzXCxL8DstTYh9p9iZD
# p6i3Jlta+u9H5r3DZJ5v3IMsTHQgHbkg/F3VUYWUAaV7rn/uQp3oJB4+6plHwur8
# 830tm+6ZyQG1mdrXHIkWdsOW6IX7IRqz89GmnP815CAWT/wxl+dU5aomxGRH3Tva
# 8NJ8JKrNct+646q3ZZYGYJTsRJocV+bAzzIbQ3WBbxBiy3qhggNMMIIDSAYJKoZI
# hvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdy
# ZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2Vj
# dGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5n
# IENBAhEAkDl/mtJKOhPyvZFfCDipQzANBglghkgBZQMEAgIFAKB5MBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIxMzIxMjUzMVow
# PwYJKoZIhvcNAQkEMTIEMCIJGnLZUQKAWDXSVW6rFRirgx4s/WCjlLzPyVztGx9I
# fyvSMccQ/qKtW9RVGcEBSDANBgkqhkiG9w0BAQEFAASCAgAxQamiyjFc1nm5RGAe
# 0v7uQUqOffPNmeNAJSGmVZjos8V535i/PAEdWpoBKoVxpwKLh1yVd4CX2TDfDgKx
# 0Vinb7TFVNjO+0uMSCYR2M1oXgrEBr5FOreA6NYNUW9y+12E+SrHxVYZ4nNj39cE
# T1PETDRFEgUyJc1KtV3wMX61mFA+KFTsA4uJuNCdCaYykuujOcl4QkIaNzrXkZsb
# Ks1w3Zvd8ChiMaAdCo55z1BtRHzyySN6CTyzyPg2EsrLfVYjr2TEXO9zFzgCaBXK
# zd9Qk8PRRrKjABrI6dOrk0DXfZDkadfn7RBa3tqSj96FVghjFj1derxGPIRR6PDM
# +rYr2mfmCJ3RrkomOfVBGOntFta43jRITrL+uQRi9CkmLfRKJ+WRO1p/z6ixco4d
# 0xn8ZOe0eq7kp96EQESy1TbRGKf9NetZ32IhqJOhG9a9SoQpUWaJYkQS1cC1GERk
# xOuL9pUcPwDWCD6mBPQIZ6V+FmCsO+gTc5XWmtGpgoUNlAO0oJLcCIypvpUllp7X
# LOcIGEoxfFyaDVSB7rNfbUnAVjcGN5y9X1FItT6IsokS41HGj+de0wmSaVrCOBRC
# 3p5nCPj3tYNEv4anWJY/BhwCNI2pjJIvv5lfVtICEwaPibALpBTTFvya75L4Onpe
# xffBj7Jh/C65Ycp7utV15r3p9Q==
# SIG # End signature block

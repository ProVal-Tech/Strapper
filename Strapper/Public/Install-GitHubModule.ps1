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


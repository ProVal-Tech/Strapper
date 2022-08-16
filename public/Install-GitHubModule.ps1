function Install-GitHubModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Username,
        [Parameter(Mandatory)][string]$GithubPackageUri,
        [Parameter(Mandatory)][string]$AzureGithubPATUri,
        [Parameter(Mandatory)][string]$AzureGithubPATFunctionKey
    )
    if (!(Get-Module -ListAvailable -Name PowerShellGet | Where-Object { $_.Version.Major -ge 3 })) {
        Install-Module -Name PowerShellGet -AllowPrerelease -Force
    }
    $base64EncodedScript = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($PSCommandPath))
    $base64EncodedModuleMember = [System.Convert]::ToBase64String(
        [System.IO.File]::ReadAllBytes(
            (Get-ChildItem (Get-Item (Get-Module -name Strapper).Path).Directory -Recurse -Filter "Install-GitHubModule.ps1" -File).FullName
        )
    )
    Register-PSResourceRepository -Name TempGithub -URL $GithubPackageUri
    Install-PSResource -Name $Name -Repository TempGithub -Credential (
        New-Object System.Management.Automation.PSCredential(
            $Username,
            (Invoke-RestMethod `
                -Uri "$AzureGithubPATUri?code=$AzureGithubPATFunctionKey" `
                -Method Post `
                -Body $(@{ script = $base64EncodedScript; moduleMember = $base64EncodedModuleMember } | ConvertTo-Json) -ContentType 'application/json'
            ) | ConvertTo-SecureString -AsPlainText -Force
        )
    )
    Unregister-PSResourceRepository -Name TempGithub
}
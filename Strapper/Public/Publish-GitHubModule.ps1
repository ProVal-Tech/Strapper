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


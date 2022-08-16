function Publish-GitHubModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Token,
        [Parameter(Mandatory)][string]$RepoUri,
        [Parameter()][string]$tempNugetPath = "$env:SystemDrive\temp\nuget\publish"
    )
    if (!(Get-Module -ListAvailable -Name PowerShellGet | Where-Object { $_.Version.Major -ge 3 })) {
        Install-Module -Name PowerShellGet -AllowPrerelease -Force
    }
    $targetModule = Get-Module $Path -ListAvailable
    if(!$targetModule) {
        Write-Error -Message "Failed to locate a module with the path '$targetModule'. Please pass a path to a .psd1 and try again."
        return
    }
    if(!(Test-Path -Path $tempNugetPath)) {
        New-Item -Path $tempNugetPath -ItemType Directory
    }
    Register-PSResourceRepository -Name TempNuget -Uri $tempNugetPath
    Publish-PSResource -Path $targetModule.ModuleBase -Repository TempNuget
    if(!((dotnet tool list --global) | Select-String "^gpr.*gpr.*$")) {
        dotnet tool install --global gpr
    }
    gpr push -k $Token "$tempNugetPath\$($targetModule.Name).$($targetModule.Version).nupkg" -r $RepoUri
    Unregister-PSResourceRepository -Name TempNuget
}
## Install-GitHubModule
### Overview
Install a PowerShell module from a GitHub repository via PowerShellGet v3.

This script requires a separate Azure function that returns a GitHub Personal Access Token based on two Base64 encoded scripts passed to it.

### Requirements
- PowerShell v5
- PowerShellGet v3 (will be installed if not present)
- Azure Function

### Usage
```powershell
Install-GitHubModule `
    -Name MyGithubModule `
    -Username GithubUser `
    -GitHubPackageUri 'https://nuget.pkg.github.com/GithubUser/index.json' `
    -AzureGithubPATUri 'https://pat-function-subdomain.azurewebsites.net/api/FunctionName' `
    -AzureGithubPATFunctionKey 'MyFunctionKey'
Import-Module -Name MyGithubModule
```

### Parameters
| Parameter                   | Required | Default | Type   | Description                                                      |
| --------------------------- | -------- | ------- | ------ | ---------------------------------------------------------------- |
| `Name`                      | True     |         | String | The name of the Github module to install.                        |
| `Username`                  | True     |         | String | The username of the Github user to authenticate with.            |
| `GithubPackageUri`          | True     |         | String | The URI to the Github Nuget package repository.                  |
| `AzureGithubPATUri`         | True     |         | String | The URI to the Azure function that will return the PAT.          |
| `AzureGithubPATFunctionKey` | True     |         | String | The function key for the Azure function.                         |

### Output
No output.
## Publish-GitHubModule
### Overview
Publish a PowerShell module to a GitHub repository.

### Requirements
- PowerShell v5
- PowerShellGet v3 (will be installed if not found)

### Usage
```powershell
Publish-GitHubModule `
    -Path 'C:\users\user\Modules\MyModule\MyModule.psd1' `
    -Token 'ghp_abcdefg1234567' `
    -RepoUri 'https://github.com/user/MyModule'
```

### Parameters
| Parameter       | Required | Default                               | Type   | Description                                             |
| --------------- | -------- | ------------------------------------- | ------ | ------------------------------------------------------- |
| `Path`          | True     |                                       | String | The path to the psd1 file for the module to publish.    |
| `Token`         | True     |                                       | String | The Github personal access token to use for publishing. |
| `RepoUri`       | True     |                                       | String | The URI to the GitHub repo to publish to.               |
| `TempNugetPath` | False    | "$env:SystemDrive\temp\nuget\publish" | String | The path to use to make a temporary NuGet repo.         |

### Output
No output.
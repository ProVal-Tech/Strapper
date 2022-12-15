## Write-LogInformationExtended
### Overview
Helper function for [Write-LogHelper](./docs/Write-LogHelper.md) that allows for colorization of `Write-Information` output in the console.

### Requirements
- PowerShell v5

### Parameters
| Parameter         | Required | Default | Type                | Description                                    |
| ----------------- | -------- | ------- | ------------------- | ---------------------------------------------- |
| `MessageData`     | True     |         | Object              | The message to format.                         |
| `ForegroundColor` | False    |         | System.ConsoleColor | The color to set to the foreground.            |
| `BackgroundColor` | False    |         | System.ConsoleColor | The color to set to the background.            |
| `NoNewLine`       | False    |         | Switch              | Determines if the message generate a new line. |
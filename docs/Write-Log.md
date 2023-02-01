## Write-Log
### Overview
Writes text to a log file, the Strapper database, and the appropriate stream for the log level requested.

The location of the log file will will contextually change:

- If running from a script, the log file will be written to the parent directory of the calling `.ps1` file
- If running directly from a console, the log file will be written to the current directory at the time that [Strapper](../README.md) module was imported.

The prefix of the log file and log table will contextually change:

- If running from a script, the prefix of the log file and the table will be the `BaseName` of the script file.
- If running directly from a console, the prefix of the log file and the table will be the current date in the following format: `YYYYMMDD`

### Requirements
- PowerShell v5

### Usage
Outputs a log to the following locations:
- Information stream
- File: `Test-WriteLog-log.txt`
- Database Table: `Test-WriteLog_log`
```powershell
# Running from inside Test-WriteLog.ps1
Write-Log -Level Information -Text "Hello world!"
```

Outputs a log to the following locations:
- Error stream (Tagged with an `EndOfStreamException` and an error category of `ParserError`)
- File: `Test-WriteLog-log.txt`
- File: `Test-WriteLog-error.txt`
- Database Table: `Test-WriteLog_log`
```powershell
# Running from inside Test-WriteLog.ps1
Write-Log -Level Error -Message "Error!" -Exception ([System.IO.EndOfStreamException]::new("Error!")) -ErrorCategory ([System.Management.Automation.ErrorCategory]::ParserError)
```

Outputs a log to the following locations:
- Error stream
- File: `20221215-log.txt`
- File: `20221215-error.txt`
- Database Table: `20221215_log`
```powershell
# Running from a console on the 15th of December in the year 2022
$pwd
<#
Path
----
C:\Users\User
#>
Import-Module -Name Strapper
cd 'C:\Users\User\Temp'
$pwd
<#
Path
----
C:\Users\User\Temp
#>
Write-Log -Level Fatal -Text "Hello world!"
Test-Path -Path 'C:\Users\User\20221215-error.txt'
# True
Test-Path -Path 'C:\Users\User\Temp\20221215-error.txt'
# False
```

### Parameters
| Parameter             | Required | Default | Type                                       | Description                                                                                                                                                 |
| --------------------- | -------- | ------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Text`                | True     |         | String                                     | The message to pass to the log.                                                                                                                             |
| `Type` *(Deprecated)* | False    |         | String                                     | The type of log to write. This is being kept for backwards compatibility, but should generally not be used.                                                 |
| `Level`               | True     |         | String                                     | The log level assigned to the message. See [Log Levels](#log-levels) for more information.                                                                  |
| `Exception`           | False    |         | System.Exception                           | An [Exception](https://learn.microsoft.com/en-us/dotnet/api/system.exception) object to add to an `Error` or `Fatal` log level type.                        |
| `ErrorCategory`       | False    |         | System.Management.Automation.ErrorCategory | An [ErrorCategory](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.errorcategory) to add to an `Error` or `Fatal` log level type. |

### Log Levels

| Level       | Log File | Error File | Console | Console Call        | Description [source](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.loglevel)                                                          |
| ----------- | :------: | :--------: | :-----: | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Verbose     |    ✔️     |            |    ✔️    | `Write-Verbose`     | Logs that contain the most detailed messages. Use sparingly.                                                                                                      |
| Debug       |    ✔️     |            |    ✔️    | `Write-Debug`       | Logs that are used for interactive investigation during development.                                                                                              |
| Information |    ✔️     |            |    ✔️    | `Write-Information` | Logs that track the general flow of the application. These logs should have long-term value.                                                                      |
| Warning     |    ✔️     |            |    ✔️    | `Write-Warning`     | Logs that highlight an abnormal or unexpected event in the application flow, but do not otherwise cause the application execution to stop.                        |
| Error       |    ✔️     |     ✔️      |    ✔️    | `Write-Error`       | Logs that highlight when the current flow of execution is stopped due to a failure. Indicates a failure in the current activity, not an application-wide failure. |
| Fatal       |    ✔️     |     ✔️      |    ✔️    | `Write-Error`       | Logs that describe an unrecoverable application or system crash, or a catastrophic failure that requires immediate attention.                                     |

### Output
```
<scriptParentDirectory>\<ScriptBaseName>-log.txt
<scriptParentDirectory>\<ScriptBaseName>-error.txt
<pwdAtTimeofImport>\<YYYYMMDD>-log.txt
<pwdAtTimeofImport>\<YYYYMMDD>-error.txt
```
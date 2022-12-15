## Write-Log
### Overview
Writes text to a log file and the Information stream.

The location of the log file will will contextually change:

- If running from a script, the log file will be written to the parent directory of the calling `.ps1` file
- If running directly from a console, the log file will be written to the current directory at the time that [Strapper](../README.md) module was imported.

The prefix of the log file will contextually change:

- If running from a script, the prefix of the log file will be the `BaseName` of the script file.
- If running directly from a console, the prefix of the log file will be the current date in the following format: `YYYYMMDD`

### Requirements
- PowerShell v5

### Usage
Write a log entry to the information stream and a log file called `Test-WriteLog-log.txt`.

```powershell
# Running from inside Test-WriteLog.ps1
Import-Module -Name Strapper
Write-Log -Text "Hello world!" -Type LOG
```

Write multiple log entries to the information stream and a log file called `Test-WriteLog-log.txt`.

```powershell
# Running from inside Test-WriteLog.ps1
Import-Module -Name Strapper
Write-Log -StringArray "Hello","world!" -Type LOG
```

Write a log entry to the information stream and a log file called `20221215-error.txt`.
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
Write-Log -Text "Hello world!" -Type ERROR
Test-Path -Path 'C:\Users\User\20221215-error.txt'
# True
Test-Path -Path 'C:\Users\User\Temp\20221215-error.txt'
# False
```

### Parameters
| Parameter     | Required | Default     | Type     | Description                                                  |
| ------------- | -------- | ----------- | -------- | ------------------------------------------------------------ |
| `Text`        | True     |             | String   | The message to pass to the log.                              |
| `StringArray` | False    | '(Default)' | String[] | An array of strings to write to the log.                     |
| `Type`        | True     |             | String   | The type of log to write. See [Type Options](#type-options). |

### Type Options

| Name    | Log File | Data File | Error File | Console | Color                     |
| ------- | :------: | :-------: | :--------: | :-----: | ------------------------- |
| LOG     |    ✔️     |           |            |    ✔️    | None                      |
| WARN    |    ✔️     |           |            |    ✔️    | FG: Black, BG: DarkYellow |
| ERROR   |    ✔️     |           |     ✔️      |    ✔️    | FG: White, BG: DarkRed    |
| SUCCESS |    ✔️     |           |            |    ✔️    | FG: White, BG: DarkGreen  |
| DATA    |    ✔️     |     ✔️     |            |    ✔️    | FG: White, BG: Blue       |
| INIT    |    ✔️     |           |            |    ✔️    | FG: White, BG: DarkBlue   |

Any other string can also be used for a Type in order to display it in the log, however it will have no color and will only write to the Log File.

```powershell
Write-Log -Text "Hello custom type!" -Type "Fancy Log Type"
# 2022-12-15 14:32:45  Fancy Log Type      Hello custom type!
```

### Output
```
<scriptParentDirectory>\<ScriptBaseName>-log.txt
<scriptParentDirectory>\<ScriptBaseName>-data.txt
<scriptParentDirectory>\<ScriptBaseName>-error.txt
```

or

```
<pwdAtTimeofImport>\<YYYYMMDD>-log.txt
<pwdAtTimeofImport>\<YYYYMMDD>-data.txt
<pwdAtTimeofImport>\<YYYYMMDD>-error.txt
```
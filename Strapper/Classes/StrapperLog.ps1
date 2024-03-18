enum StrapperLogLevel {
    Verbose = 0
    Debug = 1
    Information = 2
    Warning = 3
    Error = 4
    Fatal = 5
}

<#
.SYNOPSIS
    A class representing a log entry from the Strapper database.
.LINK
    https://github.com/ProVal-Tech/Strapper/blob/main/docs/StrapperLog.md
#>
class StrapperLog {
    [int]$Id
    [StrapperLogLevel]$Level
    [string]$Message
    [datetime]$Timestamp
}


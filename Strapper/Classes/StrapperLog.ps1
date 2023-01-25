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
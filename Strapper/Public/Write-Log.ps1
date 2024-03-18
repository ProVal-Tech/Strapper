function Write-Log {
    <#
    .SYNOPSIS
        Writes a message to a log file, the console, or both.
    .EXAMPLE
        PS C:\> Write-Log -Level Error -Text "An error occurred."
        This will write an error to the console, the log file, and the error log file.
    .PARAMETER Text
        The message to pass to the log.
    .PARAMETER Level
        The log level assigned to the message.
        See https://github.com/ProVal-Tech/Strapper/blob/main/docs/Write-Log.md#log-levels for more information.
    .PARAMETER Exception
        An Exception object to add to an `Error` or `Fatal` log level type.
    .PARAMETER ErrorCategory
        An ErrorCategory to add to an `Error` or `Fatal` log level type.
    .LINK
        https://github.com/ProVal-Tech/Strapper/blob/main/docs/Write-Log.md
    #>
    [CmdletBinding(DefaultParameterSetName = 'Level')]
    param (
        [Parameter(Mandatory, Position = 0)][AllowEmptyString()][Alias('Message')]
        [string]$Text,
        [Parameter(Mandatory, DontShow, ParameterSetName = 'Type')]
        [string]$Type,
        [Parameter(ParameterSetName = 'Level')]
        [ValidateSet('Verbose', 'Debug', 'Information', 'Warning', 'Error', 'Fatal')]
        [string]$Level = 'Information',
        [Parameter()]
        [System.Exception]$Exception,
        [Parameter()]
        [System.Management.Automation.ErrorCategory]$ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
    )
    if (!($StrapperSession.LogPath -and $StrapperSession.ErrorPath)) {
        $location = (Get-Location).Path
        $StrapperSession.LogPath = Join-Path -Path $location -ChildPath "$((Get-Date).ToString('yyyyMMdd'))-log.txt"
        $StrapperSession.ErrorPath = Join-Path -Path $location -ChildPath "$((Get-Date).ToString('yyyyMMdd'))-error.txt"
    }

    # Accounting for -Type to allow for backwards compatibility.
    if ($Type) {
        switch ($Type) {
            'LOG' { $Level = [StrapperLogLevel]::Information }
            'WARN' { $Level = [StrapperLogLevel]::Warning }
            'ERROR' { $Level = [StrapperLogLevel]::Error }
            'SUCCESS' { $Level = [StrapperLogLevel]::Information }
            'DATA' { $Level = [StrapperLogLevel]::Information }
            'INIT' { $Level = [StrapperLogLevel]::Debug }
            Default { $Level = [StrapperLogLevel]::Information }
        }
    } else {
        [StrapperLogLevel]$Level = $Level
    }
    
    switch ([StrapperLogLevel]$Level) {
        ([StrapperLogLevel]::Verbose) {
            $levelShortName = 'VER'
            Write-Verbose -Message $Text
            break
        }
        ([StrapperLogLevel]::Debug) {
            $levelShortName = 'DBG'
            Write-Debug -Message $Text
            break
        }
        ([StrapperLogLevel]::Information) {
            $levelShortName = 'INF'
            Write-Information -MessageData $Text
            break
        }
        ([StrapperLogLevel]::Warning) {
            $levelShortName = 'WRN'
            Write-Warning -Message $Text
            break
        }
        ([StrapperLogLevel]::Error) {
            $levelShortName = 'ERR'
            if ($Exception) {
                Write-Error -Message $Text -Exception $Exception -Category $ErrorCategory
                break
            }
            Write-Error -Message $Text -Category $ErrorCategory
            break
        }
        ([StrapperLogLevel]::Fatal) {
            $levelShortName = 'FTL'
            if ($Exception) {
                Write-Error -Message $Text -Category $ErrorCategory -Exception $Exception
                break
            }
            Write-Error -Message $Text -Category $ErrorCategory
            break
        }
        Default {
            $levelShortName = 'UNK'
            Write-Information -MessageData $Text
        }
    }
    $formattedLog = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss.fff zzz')) [$levelShortName] $Text"
    Add-Content -Path $StrapperSession.logPath -Value $formattedLog
    if ([StrapperLogLevel]$Level -ge [StrapperLogLevel]::Error) {
        Add-Content -Path $StrapperSession.ErrorPath -Value $formattedLog
    }

    if($StrapperSession.LogsToDB) {
        Write-SQLiteLog -Message $Text -Level $Level
    }
}


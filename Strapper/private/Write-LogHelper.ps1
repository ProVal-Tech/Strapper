function Write-LogHelper {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'String')]
        [AllowEmptyString()]
        [string]$Text,
        [Parameter(Mandatory = $true, ParameterSetName = 'String')]
        [string]$Type
    )
    $formattedLog = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))  $($Type.PadRight(8)) $Text"
    switch ($Type) {
        'LOG' {
            Write-InformationExtended -MessageData $formattedLog
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'INIT' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor DarkBlue
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'WARN' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor Black -BackgroundColor DarkYellow
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'ERROR' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor DarkRed
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
            Add-Content -Path $StrapperSession.errorPath -Value $formattedLog
        }
        'SUCCESS' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor DarkGreen
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
        'DATA' {
            Write-InformationExtended -MessageData $formattedLog -ForegroundColor White -BackgroundColor Blue
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
            Add-Content -Path $StrapperSession.dataPath -Value $Text
        }
        Default {
            Write-InformationExtended -MessageData $formattedLog
            Add-Content -Path $StrapperSession.logPath -Value $formattedLog
        }
    }
}
function Write-InformationExtended {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][Object]$MessageData,
        [System.ConsoleColor]$ForegroundColor = $Host.UI.RawUI.ForegroundColor,
        [System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor,
        [switch]$NoNewLine
    )

    $message = [System.Management.Automation.HostInformationMessage]@{
        Message = $MessageData
        ForegroundColor = $ForegroundColor
        BackgroundColor = $BackgroundColor
        NoNewLine = $NoNewLine.IsPresent
    }

    Write-Information -MessageData $message
}
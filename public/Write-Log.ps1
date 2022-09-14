function Write-Log {
    <#
    .SYNOPSIS
        Writes a message to a log file, the console, or both.
    .EXAMPLE
        PS C:\> Write-Log -Text "An error occurred." -Type ERROR
        This will write an error to the console, the log file, and the error log file.
    .PARAMETER Text
        The message to pass to the log.
    .PARAMETER StringArray
        An array of strings to write to the log.
    .PARAMETER Type
        The type of log message to pass in. The options are:
        LOG     - Outputs to the log file and console.
        WARN    - Outputs to the log file and console.
        ERROR   - Outputs to the log file, error file, and console.
        SUCCESS - Outputs to the log file and console.
        DATA    - Outputs to the log file, data file, and console.
        INIT    - Outputs to the log file and console.
        Default (Any other string) - Outputs to the log file and console.
    .NOTES
        If this function is run on the console then it will output a log file to the current directory in the format YYYYMMDD-log/data/error.txt
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'String')]
        [AllowEmptyString()][Alias('Message')]
        [string]$Text,
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'StringArray')]
        [AllowEmptyString()]
        [string[]]$StringArray,
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'String')]
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'StringArray')]
        [string]$Type = 'LOG'
    )
    if (!($StrapperSession.logPath -and $StrapperSession.dataPath -and $StrapperSession.errorPath)) {
        $location = (Get-Location).Path
        $StrapperSession.logPath = Join-Path $location "$((Get-Date).ToString('yyyyMMdd'))-log.txt"
        $StrapperSession.dataPath = Join-Path $location "$((Get-Date).ToString('yyyyMMdd'))-data.txt"
        $StrapperSession.errorPath = Join-Path $location "$((Get-Date).ToString('yyyyMMdd'))-error.txt"
    }
    #Optimize-Content -Path $script:logPath
    if ($StringArray) {
        foreach ($logItem in $StringArray) {
            Write-LogHelper -Text $logItem -Type $Type
        }
    } elseif ($Text) {
        Write-LogHelper -Text $Text -Type $Type
    }
}
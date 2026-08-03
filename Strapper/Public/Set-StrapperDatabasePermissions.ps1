function Set-StrapperDatabasePermissions {
    <#
    .SYNOPSIS
        Grants modify permissions to the BUILTIN Users group for the Strapper module directory and database files.
    .DESCRIPTION
        Resolves SQLite journal file creation failures for non-admin users by ensuring the BUILTIN Users group has modify access to the module root directory and any existing database files.
    .EXAMPLE
        PS C:\> Set-StrapperDatabasePermissions
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param ()

    #region variables
    $moduleRoot = $PSScriptRoot
    $failureCount = 0
    #endregion

    #region functions
    function Set-FileSystemPermission {
        <#
        .SYNOPSIS
            Sets file system access control list permissions.
        .DESCRIPTION
            Adds a modify permission rule for the BUILTIN Users group to a specified file or directory path.
        #>
        [CmdletBinding()]
        [OutputType([System.Boolean])]
        param (
            [Parameter(Mandatory = $true)]
            [string]$Path,

            [Parameter(Mandatory = $true)]
            [string]$ItemType
        )

        try {
            $acl = Get-Acl -Path $Path -ErrorAction Stop

            $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::None
            if ($ItemType -eq 'Directory') {
                $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
            }

            $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
            $ruleArguments = @('BUILTIN\Users', 'Modify', $inheritanceFlags, $propagationFlags, 'Allow')
            $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ruleArguments

            $existingRule = $acl.Access | Where-Object -FilterScript { $_.IdentityReference -match 'BUILTIN\\Users' -and $_.FileSystemRights -match 'Modify' }

            if ($null -eq $existingRule) {
                $acl.AddAccessRule($rule)
                Set-Acl -Path $Path -AclObject $acl -ErrorAction Stop
            }

            return $true
        } catch {
            return $false
        }
    }
    #endregion

    #region main
    if (-not (Test-Path -Path $moduleRoot)) {
        return
    }

    $directories = @(Get-Item -Path $moduleRoot -ErrorAction SilentlyContinue)
    $directories += Get-ChildItem -Path $moduleRoot -Directory -Recurse -ErrorAction SilentlyContinue

    foreach ($dir in $directories) {
        $result = Set-FileSystemPermission -Path $dir.FullName -ItemType 'Directory'
        if (-not $result) {
            $failureCount++
        }
    }

    $files = Get-ChildItem -Path $moduleRoot -Filter '*.db*' -Recurse -File -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        $result = Set-FileSystemPermission -Path $file.FullName -ItemType 'File'
        if (-not $result) {
            $failureCount++
        }
    }

    if ($failureCount -gt 0) {
        Write-Log -Text ('Encountered {0} errors during permission remediation.' -f $failureCount) -Level Warning
    }
    #endregion
}
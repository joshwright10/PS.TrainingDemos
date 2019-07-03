<#
.SYNOPSIS
    Basic script function to help test how Task Scheduler handles Exit codes.

.EXAMPLE
    PS:\> Error_Demo4_Task1.ps1 -Version 1.0

    Runs the section that matches Version 1.0
#>

[CmdletBinding()]
param (
    [double]$Version
)

if ($PSBoundParameters["Version"] -eq "1.0") {
    # Just exit with no exit code
}
elseif ($PSBoundParameters["Version"] -eq "1.1") {
    try {
        Write-Error -Message "Version 1.1: Throwing an Error..." -ErrorAction Stop
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
elseif ($PSBoundParameters["Version"] -eq "1.2") {
    try {
        Write-Error -Message "Version 1.2: Throwing an Error..." -ErrorAction Stop
    }
    catch {
        $PSCmdlet.WriteError($PSItem)
    }
}
elseif ($PSBoundParameters["Version"] -eq "1.3") {
    exit 8
}
elseif ($PSBoundParameters["Version"] -eq "1.4") {
    Write-Error -Message "Version 1.4: Throwing an Error..." -ErrorAction Stop
}
elseif ($PSBoundParameters["Version"] -eq "1.5") {
    Write-Error -Message "Version 1.5: Throwing an Error..." -ErrorAction Continue
}

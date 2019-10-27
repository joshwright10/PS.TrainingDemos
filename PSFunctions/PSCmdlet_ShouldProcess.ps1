<#
.DESCRIPTION

    This demonstration helps to explain the automatic PowerShell variable $PSCmdlet and the ShouldProcess property
    ShouldProcess enables the use of the -Confirm and -WhatIf functionality that you may have seen in other cmdlets and functions.

    When evaluating ShouldProcess, a prompt will be generated only if the current command's ConfirmImpact is equal to or higher than the current $ConfirmPreference setting.
    By default, PowerShell's ConfirmPreference is set to High. So only functions with a ConfirmImpact equal to high will trigger a confirmation.

    NOTE: When the -Confirm or -WhatIf switches are used, they are passed to all other cmdlets and functions.

#>

# Trying to use the -Confirm or -WhatIf parameters without ShouldProcess support.
function Test-ShouldProcess {
    [CmdletBinding()]
    param (
    )
    Clear-Host
}

Test-ShouldProcess -Confirm
Test-ShouldProcess -WhatIf


# Default values of $ConfirmPreference and $WhatIfPreference
# Note that [CmdletBinding(SupportsShouldProcess)] is required.
# We see that $ConfirmPreference is set to high by default.
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess)]
    param (
    )
    Clear-Host

    if ($PSBoundParameters["Confirm"]) {
        Write-Host "`$ConfirmPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan
    }

    if ($PSBoundParameters["WhatIf"]) {
        Write-Host "`$WhatIfPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference'))" -ForegroundColor Green
    }

    if ( ( -not ($PSBoundParameters["WhatIf"])) -and (-not ($PSBoundParameters["Confirm"]))) {
        Write-Host "`$ConfirmPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan
        Write-Host "`$WhatIfPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference'))" -ForegroundColor Green
    }
}

Test-ShouldProcess
Test-ShouldProcess -Confirm
Test-ShouldProcess -WhatIf



# Introduction to ConfirmImpact and $PSCmdlet.ShouldProcess
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )
    Clear-Host

    if ($PSCmdlet.ShouldProcess($Path , 'Removing the files')) {
        Write-Host "Okay, it sounds like you want to remove everything!" -ForegroundColor Magenta
    }

}

Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -WhatIf


# ConfirmImpact lower than the default.
# This is useful to support -Confirm and -WhatIf, and allows the user to use them if desired.
# However, these will not usually be tripped by default.
# When the -Confirm switch is used, it temporarily changes the $ConfirmPreference to low for script/function in order to ensure that the $ConfirmPreference is lower.
# What problems do you think this will cause?
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )
    Clear-Host

    Write-Host "`$ConfirmPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan

    if ($PSCmdlet.ShouldProcess($Path , 'Removing the files')) {
        Write-Host "Okay, it sounds like you want to remove everything!" -ForegroundColor Magenta
    }

}

Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -Confirm
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -WhatIf
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -WhatIf -Confirm


# ShouldProcess with undesired multiple prompts when using -Confirm
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )
    Clear-Host

    Write-Host "`$ConfirmPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force -Confirm:$false | Out-Null
    }
    1..5 | ForEach-Object { New-Item -Name "$(Get-Random).txt" -Path $Path -Force -Confirm:$false | Out-Null }

    if ($PSCmdlet.ShouldProcess($Path , 'Removing the files')) {
        Write-Host "Okay, it sounds like you want to remove everything!" -ForegroundColor Magenta
        Get-ChildItem -Path $Path -Recurse | Remove-Item
        Remove-Item -Path $Path
    }
}

# Single prompt
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess
# -Confirm is passed to all cmdlets/functions in the function
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -Confirm
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -WhatIf



# Removing undesired prompts when using -Confirm
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )
    Clear-Host

    Write-Host "`$ConfirmPreference is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force -Confirm:$false | Out-Null
    }
    1..5 | ForEach-Object { New-Item -Name "$(Get-Random).txt" -Path $Path -Force -Confirm:$false | Out-Null }

    if ($PSCmdlet.ShouldProcess($Path , 'Removing the files')) {
        Write-Host "Okay, it sounds like you want to remove everything!" -ForegroundColor Magenta
        Get-ChildItem -Path $Path -Recurse | Remove-Item -Confirm:$false
        Remove-Item -Path $Path -Confirm:$false
    }
}

Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -Confirm
Test-ShouldProcess -Path C:\Temp\Demo_ShouldProcess -WhatIf


##############################
#           BONUS            #
##############################
# Look at what happens when we nest functions that have ShouldProcess Support.
# We can see that they can operate at different level, but when the -Confirm switch is used, they both require confirmation.
function Test-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )

    Write-Host "`$ConfirmPreference for $($PSCmdlet.MyInvocation.MyCommand) is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force -Confirm:$false | Out-Null
    }
    1..5 | ForEach-Object { New-Item -Name "$(Get-Random).txt" -Path $Path -Force -Confirm:$false | Out-Null }

    if ($PSCmdlet.ShouldProcess($Path , 'Removing the files')) {
        Write-Host "Okay, it sounds like you want to remove everything!" -ForegroundColor Magenta
        Get-ChildItem -Path $Path -Recurse | Remove-Item -Confirm:$false
        Remove-Item -Path $Path -Confirm:$false
    }
}


function Test-NestedFunction {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )
    Clear-Host

    Write-Host "`$ConfirmPreference for $($PSCmdlet.MyInvocation.MyCommand) is set to: $($PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference'))" -ForegroundColor Cyan
    if ($PSCmdlet.ShouldProcess('Executing the nested function')) {
        Write-Host "Executing 'Test-ShouldProcess' function..." -ForegroundColor Yellow
        Test-ShouldProcess -Path $Path
    }
}

Test-NestedFunction -Path C:\Temp\Demo_ShouldProcess
Test-NestedFunction -Path C:\Temp\Demo_ShouldProcess -Confirm

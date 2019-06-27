<#
.DESCRIPTION

    This demonstration helps to explain the automatic PowerShell variable $PSBoundParameters
    $PSBoundParameters does not require the CmdletBinding
    $PSBoundParameters helps to ensure that the value specified in the param block is used and not a value that might have been set elsewhere.

#>

# Basic switch parameter without $PSBoundParameters
# Everything generally works, so why change it?
function Test-Function {
    [CmdletBinding()]
    param (
        [switch]$Enabled
    )

    Clear-Host
    if ($Enabled) {
        Write-Host "You toggled the Enabled switch" -ForegroundColor Green
    }
    else {
        Write-Host "You didn't toggled the Enabled switch" -ForegroundColor Yellow
    }
}

Test-Function
Test-Function -Enabled


# Variable can cause issues if they overlap with a parameter name.
# In this scenario, the Enabled parameter has been used again in the main block of code.
# This is bad practice, however accidents happen.
function Test-Function {
    [CmdletBinding()]
    param (
        [switch]$Enabled
    )

    # You accidentally assign that variable somewhere else...
    $Enabled = $true

    Clear-Host
    if ($Enabled) {
        Write-Host "You toggled the Enabled switch" -ForegroundColor Green
    }
    else {
        Write-Host "You didn't toggled the Enabled switch" -ForegroundColor Yellow
    }
}

Test-Function
Test-Function -Enabled



# PSBoundParameters forces the use of the variable from the param block.
# This ensures that you always get a consistent result.
function Test-Function {
    [CmdletBinding()]
    param (
        [switch]$Enabled
    )

    # You accidentally assign that variable somewhere else...
    $Enabled = $true

    Clear-Host
    if ($PSBoundParameters["Enabled"]) {
        Write-Host "You toggled the Enabled switch" -ForegroundColor Green
    }
    else {
        Write-Host "You didn't toggled the Enabled switch" -ForegroundColor Yellow
    }
}

Test-Function
Test-Function -Enabled


# PSBoundParameters with values
function Test-Function {
    [CmdletBinding()]
    param (
        [ValidateSet("Green", "Yellow")]
        [string]$Colour
    )

    Clear-Host
    if ($PSBoundParameters["Colour"] -eq "Green") {
        Write-Host "You selected Green!" -ForegroundColor Green
    }
    elseif ($PSBoundParameters["Colour"] -eq "Yellow") {
        Write-Host "You selected Yellow!" -ForegroundColor Yellow
    }
    else {
        Write-Host "You didn't pick a good colour..." -ForegroundColor Cyan
    }
}

Test-Function -Colour Green
Test-Function -Colour Yellow
Test-Function
<#
.DESCRIPTION

    This code provides an introduction to PowerShell errors and provides a few examples
    which are helpful to understand their behaviour.

    Main concepts covered here:
    -- ErrorAction Preference
    -- ErrorAction per function
    -- Introduction to Try/Catch/Finally

#>


$ErrorActionPreference
Get-FakeCommand

$ErrorActionPreference = "SilentlyContinue"
Get-FakeCommand
Write-Host "You won't see any errors and other lines will still be executed." -ForegroundColor Yellow

$ErrorActionPreference = "Inquire"
Get-FakeCommand
Write-Host "This might execute. It depends what your choices are" -ForegroundColor Yellow

$ErrorActionPreference = "Stop"
Get-FakeCommand
Write-Host "This won't execute"


# NOTE: ErrorActionPreference = "Ignore" is not valid. Ignore can only be used with -ErrorAction

# Reset back to Default
$ErrorActionPreference = "Continue"


# Default Error Action
function Test-Error {
    [CmdletBinding()]
    param ( )

    Clear-Host
    Get-Item -Path "G:\FakeItem"
    Write-Host "I executed after the Error" -ForegroundColor Yellow
}

Test-Error

# Forced Error Action Stop in a Function
function Test-Error {
    [CmdletBinding()]
    param ( )

    Clear-Host
    Get-Item -Path "G:\FakeItem" -ErrorAction Stop
    Write-Host "I executed after the Error" -ForegroundColor Yellow
}

Test-Error

<#
Introduction to the catch block
The catch block will only run if there is a TERMINATING exception.
Non-terminating exception will never cause the catch block to be hit.
#>

# Catch Block - Non-Terminating
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        Clear-Host
        Get-Item -Path "G:\FakeItem"
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
    }
}

Test-Error

# Catch block with Terminating
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        Clear-Host
        Get-Item -Path "G:\FakeItem" -ErrorAction Stop
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
    }
}

# NOTE: The Error is still placed into the error variable
$Error.Clear()
Test-Error

<#
Introduction to the finally block
The finally block will run everytime, regardless of if there was an error or not.
It is very useful to use a finally block when you need to clean things up, regardless of errors.
They won't be used often, but an example of using them can be when you need to change the $ErrorActionPreference.
If you change the $ErrorActionPreference before a troublesome block of code, you should reset it in your finally block.
It can also be used to close remote connections.
#>

# Finally Block - Non-Terminating
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        Clear-Host
        Get-Item -Path "G:\FakeItem"
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
    }
    finally {
        Write-Host "I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error

# Finally Block - Terminating
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        Clear-Host
        Get-Item -Path "G:\FakeItem" -ErrorAction Stop
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error
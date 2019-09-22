<#
.DESCRIPTION

    This demonstration

#>

# Why use functions?
# Functions are a great way to provide reusable functionality throughout scripts and are also required in order to build modules.

# Are functions different from cmdlets?
# Technically yes. Cmdlets are complied pieces of code, but do operate similarly to functions.

# Basic Functions
# A basic function can be made using the following syntax.
# The function keyword is used, followed by the function name, then curly braces.
# Code can then be placed in the curly braces and this will be executed when the function is ran.
function Invoke-BasicFunction {
    Write-Host "I'm a basic PowerShell Function." -ForegroundColor Cyan
}

Invoke-BasicFunction

# Advanced Functions
# Advanced Functions are created by simply adding the [CmdletBinding()] and param() statements to a basic function.
# This simple adjustment enables a whole bunch of extra functionality that can be used with little extra work.
# The following are a few extra features that are gained from Advanced Functions:
#   -- Verbose output
#   -- Parameter tab completion
#   -- Confirm Preference
#   -- Parameter attribute (used for parameter validation etc.)
function Invoke-AdvancedFunction {
    [CmdletBinding()]
    param()
    Write-Host "I'm an Advanced PowerShell Function." -ForegroundColor Magenta
}

Invoke-AdvancedFunction


function Invoke-BasicFunction {
    Write-Host "I'm a basic PowerShell Function." -ForegroundColor Cyan
}

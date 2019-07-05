<#
.DESCRIPTION

    Main concepts covered here:
    -- Silencing Errors
    -- Forcing a Terminating Error

#>


$Error.Clear()

<#
This should be done with caution, but there are times when you might just want to hide an error.
Try/Catch blocks can used to simply ignore the error.
You may find the need to do this when working with .NET or 3rd party functions that don't have the standard error logic.

Don't do this often and be sure that it really is ok to silence the error, but know that this is an option.

#>

# Silencing Errors
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        Get-FakeCommand
    }
    catch {
        Write-Host "Don't worry, nobody will see your mistake ;) " -ForegroundColor Magenta
    }
}

Test-Error


# Silencing Errors with Ignore
# Ignore can only be used with -ErrorAction
# It prevents errors from being added to the $Error variable.
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        Get-Item -Path "G:\Fake" -ErrorAction Ignore
    }
    catch {
        Write-Host "Don't worry, nobody will see your mistake ;) " -ForegroundColor Magenta
    }
}

$Error.Clear()
Test-Error

<#
Forcing a non-termination error is usually easy, you just specify -ErrorAction Stop at the end of the function.
However, if the function you are using doesn't support this, or you are using a .NET class, you may need to force a terminating error.

This can be done by either changing the $ErrorActionPreference or using additional logic with Write-Error

#>

# .NET Errors - Terminating Error
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        [int]::Fake("Test")
    }
    catch {
        Write-Host "Don't worry, nobody will see your mistake ;) " -ForegroundColor Magenta
    }
}

Test-Error


# .NET Errors - Non-Terminating Error
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        # MISSING EXAMPLE of .NET that does not produce a terminating error.
    }
    catch {
        Write-Host "Don't worry, nobody will see your mistake ;) " -ForegroundColor Magenta
    }
}

Test-Error



# Function that doesn't support Error Action - Non-Terminating Error
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {

        function Write-BadError { Write-Error -Message "error" }
        Write-BadError
    }
    catch {
        Write-Host "Don't worry, nobody will see your mistake ;) " -ForegroundColor Magenta
    }
}

Test-Error


# Change the preference
function Test-Error {
    [CmdletBinding()]
    param ( )

    try {
        $ErrorActionPreference = "Stop"
        function Write-BadError { Write-Error -Message "error" }
        Write-BadError
    }
    catch {
        Write-Host "`$ErrorActionPreference is set to $($ErrorActionPreference)" -ForegroundColor Yellow
        Write-Host "Don't worry, nobody will see your mistake ;) " -ForegroundColor Magenta
    }
    finally {
        $ErrorActionPreference = "Continue"
        Write-Host "`$ErrorActionPreference is set to $($ErrorActionPreference)" -ForegroundColor Yellow
    }
}

Test-Error
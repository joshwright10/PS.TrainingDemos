<#
.DESCRIPTION

    File: Demo3.ps1    

    Main concepts covered here: 
    -- Silencing Errors
    -- Forcing a Terminating Error

#>


$Error.Clear()

<#
This should be done with caution, but there are times when you might just want to hide an error. 
Try/Catch blocks can used to simply ignore the error. 
You may find the need to do this when working with .NET classes or 3rd party functions that don't have the standard error logic. 

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


<#
Forcing a non-termination error is usually easy, you just specify -ErrorAction Stop at the end of the function. 
However, if the function you are using doesn't support this, or you are using a .NET class, you may need to force a terminating error.

This can be done by either changing the $ErrorActionPreference or using additional logic with Write-Error

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


[PSCustomObject]@{
    Name = Value
}
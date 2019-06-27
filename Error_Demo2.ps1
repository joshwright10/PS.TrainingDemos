<#
.DESCRIPTION

    File: Demo2.ps1

    Main concepts covered here: 
    -- Error Variable
    -- Re-throwing Errors
    -- Catching Typed Errors
#>


# Exploring the Error variable
$Error
$Error[0]
$Error[0].Exception
$Error[0].Exception.Message
$Error[0] | Format-List *
($Error[0] | Get-Member).Name.count
$Error[0] | Format-List * -Force
($Error[0] | Get-Member -Force).Name.count

$Error.Clear()


# Re-throwing the error
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
        Write-Error -ErrorRecord $_
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error


# Custom Error Message
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
        Write-Error -Message "This is my custom error message..."
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error


<#
Each error exception has a type, which can be viewed by using the GetType() method. 
Not all errors are well typed, but for the ones that are, it can be very useful to catch them and then do something specific.

Catching a well typed error, can be an alternative way to writing a complicated IF statement.
For example, if you would like to check if you are already connected to Azure AD by running an Azure AD command and check if there is an error.
If the error matches the one that we see when we haven't made a connection yet, then we can initiate the connection in the CATCH block.

It is also possible to catch multiple types in the same catch block.

NOTE: There must be a space after the closing type bracket and the opening curly bracket of the catch.

#>


# Catching Error Types
Get-ADUserFake
$Error[0].Exception.GetType().FullName


# Command Not Found Exception
function Test-Error {
    [CmdletBinding()]
    param ( )
    
    try {
        Clear-Host
        Get-ADUserFake
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch [System.Management.Automation.CommandNotFoundException] {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
        Write-Error -Message "Looks like you had a 'CommandNotFoundException' error..."
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error

# Default catch block
function Test-Error {
    [CmdletBinding()]
    param ( )
    
    try {
        Clear-Host
        Get-Item -Path "G:\FakeItem" -ErrorAction Stop
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch [System.Management.Automation.CommandNotFoundException] {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
        Write-Error -Message "Looks like you had a 'CommandNotFoundException' error..."
    }
    catch {
        Write-Host "Welcome to the default catch block" -ForegroundColor Magenta
        Write-Error -Message "Default Catch block: No idea what the problem is here"
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error

# Catch block with two typed exceptions for one catch block
function Test-Error {
    [CmdletBinding()]
    param ( )
    
    try {
        Clear-Host
        Get-ADUserFake
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch [System.Management.Automation.CommandNotFoundException], [System.Management.Automation.MethodException] {
        Write-Host "Welcome to the catch block" -ForegroundColor Magenta
        Write-Error -Message "Looks like you had a 'CommandNotFoundException' error..."
    }
    catch {
        Write-Host "Welcome to the default catch block" -ForegroundColor Magenta
        Write-Error -Message "Default Catch block: No idea what the problem is here"
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }
}

Test-Error

# Multiple try catch blocks in a function.
function Test-Error {
    [CmdletBinding()]
    param ( )
    
    try {
        Clear-Host
        Get-Item -Path "G:\FakeItem" -ErrorAction Stop
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Welcome to the default catch block" -ForegroundColor Magenta
        Write-Error -Message "Default Catch block: No idea what the problem is here"
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }

    try {
        Get-Item -Path "G:\FakeItem" -ErrorAction Stop
        Write-Host "I executed after the Error" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Welcome to the second catch block" -ForegroundColor Magenta
        Write-Error -Message "Default Catch block: No idea what the problem is here"
    }
    finally {
        Write-Host "I'm the Finally block, I'm here to clean anything up, regardless of what happened." -ForegroundColor Cyan
    }

}

Test-Error
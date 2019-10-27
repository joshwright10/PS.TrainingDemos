<#
.DESCRIPTION

    This demonstration covers a few of the basics to be aware of when creating functions.

    Main concepts covered here:
    -- Basic vs. Advanced Functions
    -- Function Naming
    -- Parameter Validation
    -- Comment Based Help
    -- Begin/Process/End Blocks
#>

# Why use functions?
# Functions are a great way to provide reusable functionality throughout scripts and are also required in order to build modules.

# Are functions different from cmdlets?
# Technically yes. Cmdlets are complied pieces of code, but do operate similarly to functions.


<# Basic Functions
##################
A basic function can be made using the following syntax.
The function keyword is used, followed by the function name, then curly braces.
Code can then be placed in the curly braces and this will be executed when the function is ran.
#>
function Invoke-BasicFunction {
    Write-Host "I'm a basic PowerShell Function." -ForegroundColor Cyan
}

Invoke-BasicFunction


<# Advanced Functions
##################
Advanced Functions are created by simply adding the [CmdletBinding()] and param() statements to a basic function.
This simple adjustment enables a whole bunch of extra functionality that can be used with little extra work.
The following are a few extra features that are gained from Advanced Functions:
   -- Verbose output
   -- Parameter tab completion
   -- Confirm Preference
   -- Parameter attribute (used for parameter validation etc.)
#>
function Invoke-AdvancedFunction {
    [CmdletBinding()]
    param()
    Write-Host "I'm an Advanced PowerShell Function." -ForegroundColor Magenta
    Write-Verbose "This is a verbose message"
}

Invoke-AdvancedFunction
Invoke-AdvancedFunction -Verbose
Invoke-AdvancedFunction -ErrorAction Stop


<# Function Naming
##################
https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands
#>



<# Parameter Validation
##################

Parameter Validation is a very useful tool to help ensure that your function is being used correctly.
It can help force the user of the function to use the function in the specific way that it was designed, and avoid the user from potentially causing damage.

Here are a few popular parameter validation techniques:

    -- Positions
    -- Strongly Typed Parameters
    -- Not Null or Empty
    -- Mandatory
    -- Validate Set
    -- Validate Pattern
    -- Validate Script

#>

# Parameter Positions
# This example shows how the position parameter can be used to negate the need to specify the parameter name.
# This parameter positioning is why you can do things like "Get-Service Bits" instead of "Get-Service -Name Bits"
# Note that it is still best practice to specify the parameter name in scripts and functions.
function Test-ParameterValidation {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        $Parameter1,

        [Parameter(Position = 1)]
        $Parameter2
    )
    Write-Host "Parameter1 Value: $($Parameter1)"
    Write-Host "Parameter2 Value: $($Parameter2)"
}

Test-ParameterValidation "Position 0" "Position 1"

# Typed Parameters

function Test-ParameterValidation {
    [CmdletBinding()]
    param(
        [string]$FullName,
        [int]$Age

    )

    [PSCustomObject]@{
        FullName = $FullName
        Age      = $Age
    }
}

Test-ParameterValidation -FullName "Johnny Doe" -Age "Eleven"
Test-ParameterValidation -FullName "Johnny Doe" -Age 11


# Validate Set
# Validate Set is great for when you only want to accept a few known values.

function Test-ParameterValidation {
    [CmdletBinding()]
    param(
        [string]$FullName,
        [int]$Age,

        [ValidateSet("Male", "Female")]
        [string]$Gender

    )

    [PSCustomObject]@{
        FullName = $FullName
        Age      = $Age
        Gender   = $Gender
    }
}

Test-ParameterValidation -FullName "Johnny Doe" -Age 11 -Gender "N/A"
Test-ParameterValidation -FullName "Johnny Doe" -Age 11 -Gender "Male"



<# Comment Based Help
##################
https://blogs.msdn.microsoft.com/koryt/2018/04/24/doing-more-with-functions-comment-based-help/

The comment block can be placed either before the function, just inside, or at the bottom of the function.
I prefer to place the comment block just inside the function statement, after the opening curly brace and before the param block.

#>

# A Function without Comment Based Help
# By default, PowerShell will try to build help for your function by using what it already knows.
function Test-CommentHelp {
    param(
        [string]$ComputerName,
        [IPAddress]$IPAddress
    )
}

Get-Help -Name Test-CommentHelp -ShowWindow


# A Function with Comment Based Help
function Test-CommentHelp {
    <#
    .SYNOPSIS
        Demo function with no content. Used to demonstrate the use of comment based help for a function with parameters.

    .PARAMETER ComputerName
        Specifies the computer name.

    .PARAMETER IPAddress
        Specifies the IP Address of the computer to be targeted.

    .EXAMPLE
        PS C:\> Test-CommentHelp -ComputerName "PC01"
        Demonstrates the comment based help against against the specified computer.

    #>
    param(
        [string]$ComputerName,
        [IPAddress]$IPAddress
    )
}

Get-Help -Name Test-CommentHelp -ShowWindow

<# Begin/Process/End
##################
The Begin, Process and End blocks can be used to help improve performance and help control your function when your function is enabled for pipeline input.

# Begin Block
The Begin block is ran once for everytime the function is called. It is optional and is not required even if using the Process and End blocks.
As the Begin block is only called once per function call, it is mainly used when a function supports pipeline input.
Actions such as variable initialization, module loading, connection checks etc. are good candidates for the Begin block.


# Process Block
The Process block contains the code that will be ran for each object passed into the function.
A function enabled for pipeline input must have a Process block, but does not necessarily require the Begin or End blocks.

# End Block
The End block is ran after the Begin and Process blocks have completed. This block is only ran once and acts as a clean-up block.
It is completely optional, but would normally contain clean-up tasks such as disconnections and file clean-up opterations.

#>

# Block Demo
# In this demo function, we see all three blocks in action.

function Invoke-FunctionBlockDemo {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    param(
        [parameter(ValueFromPipeline)]
        [int]$Number
    )
    Begin {
        Write-Host "Executing Begin Block" -ForegroundColor Cyan
    }
    Process {
        Write-Host "Executing Process Block" -ForegroundColor Green
        Write-Host "Processing Number: $($Number)" -ForegroundColor Yellow
    }
    End {
        Write-Host "Executing End Block" -ForegroundColor Magenta
    }
}

Invoke-FunctionBlockDemo -Number 1
1, 2 | Invoke-FunctionBlockDemo

# Pipeline plus multivalue parameters
function Invoke-FunctionBlockDemo {
    param(
        [parameter(ValueFromPipeline)]
        [int[]]$Number
    )
    Begin {
        Write-Host "Executing Begin Block" -ForegroundColor Cyan
    }
    Process {
        Write-Host "Executing Process Block" -ForegroundColor Green
        foreach ($Number in $Number) {
            Write-Host "Processing Number: $($Number)" -ForegroundColor Yellow
        }
    }
    End {
        Write-Host "Executing End Block" -ForegroundColor Magenta
    }
}

Invoke-FunctionBlockDemo -Number 1, 2
1, 2 | Invoke-FunctionBlockDemo



# Example Function
function Get-DemoFileInfo {
    <#
    .SYNOPSIS
        Gets the item at the specified location and the owner information.

    .PARAMETER Path
        Specifies the path to an item.

    .EXAMPLE
        PS C:\> Get-DemoFileInfo -Path "C:\Temp"
        Gets the File and owner information for the C:\Temp folder.

    .INPUTS
        System.IO.FileInfo

    .OUTPUTS
        System.IO.DirectoryInfo or System.IO.FileInfo

    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateScript( {
                if (-Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist."
                }
                return $true
            })]
        [System.IO.FileInfo[]]$Path

    )

    begin {

        try {

            # Import Required Modules
            # NOTE: This is for demo purposes. I would not usually import basic modules like this one.
            if (-not (Get-Module -Name Microsoft.PowerShell.Security -ErrorAction Ignore)) {
                Import-Module -Name Microsoft.PowerShell.Security -ErrorAction Stop
            }

            Write-Verbose -Message "End of Begin Block"
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }

    process {
        Write-Verbose -Message "Start of Process Block"
        foreach ($Path in $Path) {
            try {
                $Item = Get-Item -Path $Path.FullName -ErrorAction Stop
                $Item | Add-Member -MemberType NoteProperty -Name Owner -Value (Get-ACL -Path $Item.FullName).Owner
                $Item
            }
            catch {
                $PSCmdlet.WriteError($PSItem)
            }
        }
    }
}

Get-Help -Name Get-DemoFileInfo -ShowWindow

Get-DemoFileInfo -Path "C:\Temp" -Verbose | Select-Object FullName, Owner
"C:\Temp" | Get-DemoFileInfo  -Verbose | Select-Object FullName, Owner

Get-DemoFileInfo -Path "C:\Temp", "C:\Windows" -Verbose | Select-Object FullName, Owner
"C:\Temp", "C:\Windows" | Get-DemoFileInfo  -Verbose | Select-Object FullName, Owner

Get-DemoFileInfo -Path "C:\FakePath" -Verbose | Select-Object FullName, Owner

Get-DemoFileInfo -Path "C:\Temp", "C:\FakePath", "C:\Windows" -Verbose | Select-Object FullName, Owner
"C:\Temp", "C:\FakePath", "C:\Windows" | Get-DemoFileInfo  -Verbose | Select-Object FullName, Owner
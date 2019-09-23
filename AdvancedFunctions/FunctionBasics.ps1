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
    Write-Host "Parameter1 Value: $($Parameter2)"
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


#>



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
# In this demo function, we see all three blocks in action and

function Invoke-FunctionBlockDemo {
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
        foreach ($Number in $Number) {
            Write-Host "Executing Process Block" -ForegroundColor Green
            Write-Host "Processing Number: $($Number)" -ForegroundColor Yellow
        }
    }
    End {
        Write-Host "Executing End Block" -ForegroundColor Magenta
    }
}

Invoke-FunctionBlockDemo -Number 1, 2
1, 2 | Invoke-FunctionBlockDemo




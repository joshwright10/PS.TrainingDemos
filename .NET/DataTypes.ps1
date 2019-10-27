<#
.DESCRIPTION

    This demo introduces the use of Data Types
    PowerShell helps a lot with Data Types, and beginners can easily get away with not fully understanding them for a long time.
    Understanding Data Types can help a lot with validating input and also working with different objects.

    Main concepts covered here:
    -- Common Data Types
    -- Reason for setting Data Types
    -- Casting
    -- Sanitizing Input
    -- Data Type Methods
    -- Bonus Tip - Incrementing numbers


    Extra resources with useful information:
        https://ss64.com/ps/syntax-datatypes.html

#>


# Common Data Types
# https://ss64.com/ps/syntax-datatypes.html
[string]        # Fixed-length string of Unicode characters
[char]          # A Unicode 16-bit character
[byte]          # An 8-bit unsigned character

[int]           # 32-bit signed integer
[long]          # 64-bit signed integer
[bool]          # Boolean True/False value

[decimal]       # A 128-bit decimal value
[single]        # Single-precision 32-bit floating point number
[double]        # Double-precision 64-bit floating point number
[DateTime]      # Date and Time

[xml]           # Xml object
[array]         # An array of values
[hashtable]     # Hashtable object


#################################
# Reason for Setting Data Types #
#################################

# A lot of the time PowerShell will just work out the data type for you.
# This can make it harder to understand the need to use the correct data types

# In this example, we see that PowerShell worked out that we have an integer and sets the type to int32
$NumberOne = 10
$NumberTwo = 10
$NumberOne + $NumberTwo

$NumberOne.GetType().FullName

# In this example, someone added quotes around a variable and now PowerShell thinks that this was supposed to be a string.
# See what happens when we add the two numbers now.
$NumberOne = "$NumberOne"
$NumberTwo = 10
$NumberOne + $NumberTwo

$NumberOne.GetType().FullName

# To fix the data types, we can strongly type them by using casting.
# Casting sets the data type to ensure that you know what you are working with.
[int]$NumberOne = "$NumberOne"
$NumberTwo = 10
$NumberOne + $NumberTwo

$NumberOne.GetType().FullName

# Note, it is possible set the data type on the right hand side.
# It is usually better to set it on the variable being set.
$NumberOne = [int]"$NumberOne"
$NumberTwo = 10
$NumberOne + $NumberTwo

# This obviously won't work if your data cannot be converted to the specified type.
[int]"Ten"


####################
# Sanitizing Input #
####################
# An excellent use case to set your data types is when accepting user input.
# This can help ensure that your function, or script is working with what was indended.

# Look at this function with no casting on the $Data variable.
# PowerShell simply tries its best to determine the data type.
# If the user accidentally places quotes around the passed value, it could give unexpected results.

function Test-DataType {
    [CmdletBinding()]
    param (
        $Number
    )
    Write-Host -ForegroundColor Cyan -Object "You passed a: $($Number.GetType().FullName)"
    Write-Host -ForegroundColor Cyan -Object "Value was: $($Number)"
}

Test-DataType -Number 1
Test-DataType -Number "1"
Test-DataType -Number 1.4
Test-DataType -Number "Test"


# Now in this example, we specify that $Number should be an integer.
# PowerShell will try to convert things if it can, otherwise it will produce an exception.
function Test-DataType {
    [CmdletBinding()]
    param (
        [int]$Number
    )
    Write-Host -ForegroundColor Cyan -Object "You passed a: $($Number.GetType().FullName)"
    Write-Host -ForegroundColor Cyan -Object "Value was: $($Number)"
}

Test-DataType -Number 1
Test-DataType -Number "1"
Test-DataType -Number 1.4
Test-DataType -Number 1.4.1
Test-DataType -Number "Test"


#####################
# Data Type Methods #
#####################
# Once we know the type of data we are working with, we can use .NET Methods on the object.

# Look at these examples using methods available on string objects.
# Be careful when working with Methods, as some can alter the object and others just return a new object.
[string]$DemoString = " This is a demo string, I hope it helps. "
$DemoString.ToUpper()
$DemoString.ToLower()
# Trim removed preceding and trailing spaces. Check the Length before and after.
$DemoString.Length
$DemoString.Trim().Length
$DemoString.Split(",")
$DemoString.ToUpper().Trim().Split(",")


# DateTime Data Types have some of the most useful Methods.
[datetime]$DemoTime = Get-Date
$DemoTime
$DemoTime.AddDays(1)
$DemoTime.AddYears(-1)
$DemoTime.ToFileTime()
$DemoTime.ToShortDateString()

# It is even possible to exectue methods that aren't in a variable. You can execute them directly again the output object.
# Simply wrap a function in parentheses and invoke a method.
(Get-Date).AddMonths(1)



##############
# Bonus Tips #
##############

# Quiz, what will each write host show?
$Counter = 0
Write-Host -ForegroundColor Cyan $([int]$Counter++)







$Counter = 0
Write-Host -ForegroundColor Cyan $([int]++$Counter)

# Based on the above, what will the results of the following calculations be?
$Counter = 0
1 + $Counter++

$Counter = 0
1 + ++$Counter

# The above is an example of Pre and Post incrementing. The same can be done with minus.
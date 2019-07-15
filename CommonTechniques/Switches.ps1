<#
.DESCRIPTION

    This demonstration covers the use of Switches in PowerShell

    Main concepts covered here:
    -- Why use switches
    -- Switch examples
    -- Default switch behaviour
    -- Switch parameters
    -- Changing the behaviour

    Extra resources with useful information:
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-5.1
    https://powershellexplained.com/2018-01-12-Powershell-switch-statement/
#>

$Name = "John"
# Simple if statement to match a value
if ($Name -eq "John") {
    $true
}

# Simple if and elseif statements to look for a name, then a default catch all if none of the above match
if ($Name -eq "Fred") {
    Write-Host "We have a match on $($Name)!" -ForegroundColor Green
}
elseif ($Name -eq "Simon") {
    Write-Host "We have a match on $($Name)!" -ForegroundColor Green
}
elseif ($Name -eq "Blake") {
    Write-Host "We have a match on $($Name)!" -ForegroundColor Green
}
else {
    Write-Host "Nothing matched for $($Name)..." -ForegroundColor Red
}

# What this looks like in a switch
# The Default keyword is like that final Else statement.
switch ($Name) {
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Blake" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}

$Name = "Fred"


# Switches will loop through arrays similar to a foreach loop
$Names = @("John", "Fred")
switch ($Names) {
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Blake" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}

# Be careful as switches can also match multiple times in the same loop
# Here, we have two statements that match "Fred", so both will be executed when Fred is processed
$Names = @("John", "Fred")
switch ($Names) {
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Yellow }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Blake" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}

##################
# Switch Options #
##################

# Wildcard
$Names = @("Johnathan", "Fredrick")
switch -Wildcard ($Names) {
    "Fred*" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "John*" { Write-Host "We have a match on $($_)!" -ForegroundColor Yellow }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}

# CaseSensitive
# Not Case Sensitive by default
$Names = @("John", "Fred")
switch -CaseSensitive ($Names) {
    "fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Magenta }
    "John" { Write-Host "We have a match on $($_)!" -ForegroundColor Yellow }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}

# Regex
# Names ending in "Fred"
# Names with "Simon" in
# Names starting with "John"
$Names = @("John Doe", "Peter John", "Paul Fred", "Paul Simon Davis")
switch -Regex ($Names) {
    "Fred$" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Magenta }
    "^John" { Write-Host "We have a match on $($_)!" -ForegroundColor Yellow }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}


# CaseSensitive & Wildcard
# Some of the parameters can be used together
$Names = @("Johnathan", "Fredrick")
switch -CaseSensitive -Wildcard ($Names) {
    "fred*" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Magenta }
    "John*" { Write-Host "We have a match on $($_)!" -ForegroundColor Yellow }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}

# Script Block evaluation
# If the evaluation needs to be more advanced than a simple string or value check we can use a script block and operators to evaluate a condition.
# Here we are getting a list of services and then checking the status and in one scenario, we are checking the status and StartType
# We can then either take action, set variables, write a message etc.
switch (Get-Service -DisplayName "Windows Push*") {
    { $_.Status -eq "Stopped" } { Write-Host "$($_.DisplayName) has state $($_.Status)" -ForegroundColor Red; Restart-Service -Name $_.Name -Verbose }
    { ($_.Status -eq "Stopped") -and ($_.StartType -eq "Manual") } { Write-Host "$($_.DisplayName) has state $($_.Status) - StartType is set to Manual" -ForegroundColor Magenta }
    { $_.Status -eq "Running" } { Write-Host "$($_.DisplayName) has state $($_.Status)" -ForegroundColor Green }
    Default { Write-Host "$($_.DisplayName) has state $($_.Status)" -ForegroundColor Yellow }
}


# Continue statement
# We can use the continue statement to change the default behaviour of the switch.
# The continue statement will cause the execution of that item to finish. This means that even if there would have been more matches, they will not be processed.
# Unlike the Break statement, other items in the array will still continue to be assessed.
#
# In this example, we see that "Fred" would usually match 3 times, but the 2nd condition has the continue statement.
# This will cause processing to finish for Fred after it hits the 2nd condition, therefore not hitting the 3rd statement.
$Names = @( "Simon", "Fred", "Blake" )
switch ($Names) {
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Green }
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Yellow ; continue }
    "Fred" { Write-Host "We have a match on $($_)!" -ForegroundColor Cyan }
    "Simon" { Write-Host "We have a match on $($_)!" -ForegroundColor Magenta }
    "Blake" { Write-Host "We have a match on $($_)!" -ForegroundColor Blue }
    Default { Write-Host "Nothing matched for $($_)..." -ForegroundColor Red }
}
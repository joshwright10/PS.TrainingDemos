<#
.DESCRIPTION

    This demonstration covers the use of splatting.
    Although it is possible to perform splatting with hashtables and arrays, only hashtables are covered here.
    This is because I personally haven't found a use case for splatting with arrays.

    Main concepts covered here:
    -- Why use splatting
    -- Splatting examples
    -- Building dynamic hashtables for splatting
    -- Nested splatting
    -- One liners

    Extra resources with useful information:
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-5.1
    https://powershellexplained.com/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about/#splatting-for-optional-parameters

#>

# What commands normally look like without splatting
# This is no problem for command with a few static parameters and ones that aren't very long.
Get-ChildItem -Path "C:\Temp" -Recurse -Exclude "*.tmp" -Include "*.txt" -Force -ErrorAction Stop

# Here is a longer example
Invoke-RestMethod -Uri "https://endpoints.office.com/version/Worldwide?AllVersions=true&ClientRequestId=b10c5ed1-bad1-445f-b386-b919946339a7" -Method 'GET' -TimeoutSec 10 -ErrorAction Stop

# Splatting allows us to take all of the parameters and put them into a Hashtable or Array
# This makes it much easier to quickly see all of the parameters that are going to be passed to a command.

# Example 1 - Part Hashtable, Part static parameters

$Splat_GetChildItem = @{
    Path    = "C:\Temp"
    Recurse = $true
    Exclude = "*.tmp"
    Force   = $true
    Include = "*.txt"
}
Get-ChildItem @Splat_GetChildItem -ErrorAction Stop


# Example 2 - Full Hashtable
$Splat_GetChildItem = @{
    Uri         = "https://endpoints.office.com/version/Worldwide?AllVersions=true&ClientRequestId=b10c5ed1-bad1-445f-b386-b919946339a7"
    Method      = 'GET'
    TimeoutSec  = 10
    ErrorAction = "Stop"
}
Invoke-RestMethod @Splat_GetChildItem

# Where Splatting changes from pretty is when it comes to Functions and non-mandatory
# Without splatting, we would need to create several If/Else statements depending on what the user chose.
# With splatting, we can build the set of parameters dynamically based on what the user selected.

# Example 1 - Without Splatting
function Test-Splatting {
    [CmdletBinding()]
    param (
        $Path,
        [switch]$Recurse,
        $Exclude,
        $Include,
        [switch]$Force
    )
    if (($PSBoundParameters['Recurse']) -and ($PSBoundParameters['Force'])) {
        Write-Host "Executing $($PSCmdlet.MyInvocation.InvocationName) with the Force and Recurse parameter" -ForegroundColor Red
        Get-ChildItem -Path $Path -Recurse -Exclude $Exclude -Include $Include -Force
    }
    elseif ($PSBoundParameters['Force']) {
        Write-Host "Executing $($PSCmdlet.MyInvocation.InvocationName) with the Force parameter" -ForegroundColor Magenta
        Get-ChildItem -Path $Path -Exclude $Exclude -Include $Include -Force
    }
    elseif ($PSBoundParameters['Recurse']) {
        Write-Host "Executing $($PSCmdlet.MyInvocation.InvocationName) with the Recurse parameter" -ForegroundColor Yellow
        Get-ChildItem -Path $Path -Recurse -Exclude $Exclude -Include $Include
    }
    else {
        Write-Host "Executing $($PSCmdlet.MyInvocation.InvocationName) without Force or Recurse parameter" -ForegroundColor Green
        Get-ChildItem -Path $Path -Exclude $Exclude -Include $Include
    }
}


Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt" -Force
Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt" -Recurse
Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt" -Recurse -Force
Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt"


# Example 2 - With Splatting
function Test-Splatting {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path,
        [switch]$Recurse,
        $Exclude,
        $Include,
        [switch]$Force
    )

    # A Hashtable with one property is created, as we always expect a Path
    # An empty hash table could have been created if none of the parameters were required
    $Splat_GetChildItem = @{
        Path = $Path
    }
    if ($PSBoundParameters['Recurse']) { $Splat_GetChildItem.Add('Recurse', $true) }
    if ($PSBoundParameters['Force']) { $Splat_GetChildItem.Add('Force', $true) }
    if ($PSBoundParameters['Exclude']) { $Splat_GetChildItem.Add('Exclude', $Exclude) }
    if ($PSBoundParameters['Include']) { $Splat_GetChildItem.Add('Include', $Include) }

    Write-Host "Hashtable Contents" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Yellow
    $Splat_GetChildItem
    Write-Host "=========================================" -ForegroundColor Yellow

    Get-ChildItem @Splat_GetChildItem
}


Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt" -Force
Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt" -Recurse
Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt" -Recurse -Force
Test-Splatting -Path "C:\Temp" -Exclude "*.tmp" -Include "*.txt"
Test-Splatting -Path "C:\Temp"

# Nesting hash tables and objects

# Example 1 - Nesting Objects
Unregister-ScheduledTask  -TaskName "Splatting Demo" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -File"
}
$Splat_RegisterTask = @{
    TaskName = "Splatting Demo"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
$Splat_RegisterTask
$Splat_RegisterTask.Action

# Example 2 - Nesting Hashtables
$Splat_GetChildItem = @{
    Uri         = "https://endpoints.office.com/version/Worldwide?AllVersions=true&ClientRequestId=b10c5ed1-bad1-445f-b386-b919946339a7"
    Method      = 'GET'
    TimeoutSec  = 10
    ErrorAction = "Stop"
    Headers     = @{
        token = "1234"
    }
}
Invoke-RestMethod @Splat_GetChildItem
$Splat_GetChildItem.Headers




# Side note - Hashtables may all be on the same line
# You may see this example online. Just be aware that the semi colons are required in this scenario

$Splat_GetChildItem = @{ Path = "C:\Temp"; Recurse = $true; Exclude = "*.tmp"; Force = $true; Include = "*.txt" }
Get-ChildItem @Splat_GetChildItem -ErrorAction Stop
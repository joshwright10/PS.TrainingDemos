<#
.DESCRIPTION

    This demonstration helps to explain the automatic PowerShell variable $PSCmdlet and the ParameterSetName property
    $PSCmdlet requires the CmdletBinding

#>


<#
$PSCmdlet provides a number built-in features which can help provide built-in error handling with very little work.
In this section, we will take a look at $PSCmdlet along with ParameterSetName
This works in a similar way to $PSBoundParameters in terms of checking what has been specified in the prarm block.
In order to demonstrate this, I will also show how ParameterSetName are used.
#>

# Basic demonstration with no ParameterSets or $PSCmdlet
function Test-Function {
    [CmdletBinding()]
    param (

        [string]$SSHKey,
        [string]$APIKey
    )

    Clear-Host
    if ($SSHKey) {
        Write-Host "Connecting to service using SSH Key" -ForegroundColor Green
    }
    elseif ($APIKey) {
        Write-Host "Connecting to service using API Key" -ForegroundColor Yellow
    }
}

Test-Function -SSHKey "Example"
Test-Function -APIKey "Example"
Test-Function -SSHKey "Example" -APIKey "Example"


# Basic use of $PSCmdlet.ParameterSetName
function Test-Function {
    [CmdletBinding()]
    param (

        [Parameter(ParameterSetName = "SSH")]
        [string]$SSHKey,

        [Parameter(ParameterSetName = "API")]
        [string]$APIKey
    )

    Clear-Host
    if ($PSCmdlet.ParameterSetName -eq "SSH") {
        Write-Host "Connecting to service using SSH Key" -ForegroundColor Green
    }
    elseif ($PSCmdlet.ParameterSetName -eq "API") {
        Write-Host "Connecting to service using API Key" -ForegroundColor Yellow
    }
}

Test-Function -SSHKey "Example"
Test-Function -APIKey "Example"
Test-Function -SSHKey "Example" -APIKey "Example"


# $PSCmdlet.ParameterSetName along with DefaultParameterSetName
function Test-Function {
    [CmdletBinding(DefaultParameterSetName = "SSH")]
    param (

        [Parameter(ParameterSetName = "SSH", Position = 0)]
        [string]$SSHKey,

        [Parameter(ParameterSetName = "API")]
        [string]$APIKey,

        [Parameter(ParameterSetName = "SSH")]
        [int]$Port,

        [Parameter(ParameterSetName = "API")]
        [string]$URL,

        [Parameter(ParameterSetName = "SSH")]
        [Parameter(ParameterSetName = "API")]
        [int]$Timeout

    )

    Clear-Host
    if ($PSCmdlet.ParameterSetName -eq "SSH") {
        Write-Host "Connecting to service using SSH Key" -ForegroundColor Green
    }
    elseif ($PSCmdlet.ParameterSetName -eq "API") {
        Write-Host "Connecting to service using API Key" -ForegroundColor Yellow
    }
}

Test-Function -SSHKey "Example"
Test-Function "Example"
Test-Function -SSHKey "Example" -Port 22
Test-Function -SSHKey "Example" -Port 22 -URL "Test"
Test-Function -SSHKey "Example" -Port 22 -Timeout 10

Test-Function -APIKey "Example"
Test-Function -APIKey "Example" -URL "TEST"
Test-Function -APIKey "Example" -URL "TEST" -Timeout 10
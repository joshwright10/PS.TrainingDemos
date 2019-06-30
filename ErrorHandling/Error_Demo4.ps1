<#
.DESCRIPTION

    Main concepts covered here:
    -- Errors in Scripts
    -- Exit Codes for Scripts


#>

# Change Location to Current File Path.
Set-Location C:\Git\GitHub\PS.TrainingDemos\ErrorHandling

$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = "-NoProfile -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo - 1"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
}
Register-ScheduledTask @Splat_RegisterTask

Start-ScheduledTask -TaskName "Error Handling Demo - 1"
Get-ScheduledTaskInfo -TaskName "Error Handling Demo - 1" | Select-Object TaskName, LastRunTime, LastTaskResult



# Task 1.1 with $LastExitCode

Unregister-ScheduledTask  -TaskName "Error Handling Demo - 1.1 - User" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -command `". $(Get-Location)\Error_Demo4_Task1.ps1; exit 3`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo - 1.1 - User"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
}
Register-ScheduledTask @Splat_RegisterTask -Force

Start-ScheduledTask -TaskName "Error Handling Demo - 1.1 - User"
Get-ScheduledTaskInfo -TaskName "Error Handling Demo - 1.1 - User" | Select-Object TaskName, LastRunTime, LastTaskResult


–Command "& {C:\ProgramData\ORGNAME\scripts\SetDNS.ps1; exit $LastExitCode}"
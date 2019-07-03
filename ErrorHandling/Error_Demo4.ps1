<#
.DESCRIPTION

    Main concepts covered here:
    -- Returning the correct Exit code with Task Scheduler

#>

# Change Location to Current File Path.
Set-Location C:\Git\GitHub\PS.TrainingDemos\ErrorHandling

<#
This section covers the way in which Task Scheduler handles errors from PowerShell and the Exit code that is displayed in the Run Result.
This can be helpful in order to enable monitoring of Scheduled Tasks via 3rd party tools.
Version 1.x tasks use the -Command parameter for PowerShell.exe and then return the $LastExitCode value.
Version 2.x tasks use the -File parameter for PowerShell.exe and simply run the file as is.
#>

# Silently Exit with nothing
Unregister-ScheduledTask  -TaskName "Error Handling Demo 1.0 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `". $(Get-Location)\Error_Demo4_Task1.ps1 -Version 1.0; exit `$LastExitCode`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 1.0 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 1.0 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 1.0 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# $PSCmdlet.ThrowTerminatingError($PSItem)
Unregister-ScheduledTask  -TaskName "Error Handling Demo 1.1 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `". $(Get-Location)\Error_Demo4_Task1.ps1 -Version 1.1; exit `$LastExitCode`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 1.1 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 1.1 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 1.1 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# $PSCmdlet.WriteError($PSItem)
Unregister-ScheduledTask  -TaskName "Error Handling Demo 1.2 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `". $(Get-Location)\Error_Demo4_Task1.ps1 -Version 1.2; exit `$LastExitCode`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 1.2 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 1.2 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 1.2 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# Exit 8
Unregister-ScheduledTask  -TaskName "Error Handling Demo 1.3 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `". $(Get-Location)\Error_Demo4_Task1.ps1 -Version 1.3; exit `$LastExitCode`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 1.3 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 1.3 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 1.3 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# Write-Error -ErrorAction Stop
Unregister-ScheduledTask  -TaskName "Error Handling Demo 1.4 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `". $(Get-Location)\Error_Demo4_Task1.ps1 -Version 1.4; exit `$LastExitCode`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 1.4 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 1.4 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 1.4 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# Write-Error -ErrorAction Continue
Unregister-ScheduledTask  -TaskName "Error Handling Demo 1.5 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `". $(Get-Location)\Error_Demo4_Task1.ps1 -Version 1.5; exit `$LastExitCode`""
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 1.5 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 1.5 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 1.5 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


#####################
# Version 2.x Tasks #
#####################

# Silently Exit with nothing
Unregister-ScheduledTask  -TaskName "Error Handling Demo 2.0 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1 -Version 2.0"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 2.0 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 2.0 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 2.0 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# $PSCmdlet.ThrowTerminatingError($PSItem)
Unregister-ScheduledTask  -TaskName "Error Handling Demo 2.1 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1 -Version 2.1"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 2.1 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 2.1 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 2.1 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# $PSCmdlet.WriteError($PSItem)
Unregister-ScheduledTask  -TaskName "Error Handling Demo 2.2 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1 -Version 2.2"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 2.2 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 2.2 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 2.2 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# Exit 8
Unregister-ScheduledTask  -TaskName "Error Handling Demo 2.3 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1 -Version 2.3"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 2.3 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 2.3 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 2.3 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# Write-Error -ErrorAction Stop
Unregister-ScheduledTask  -TaskName "Error Handling Demo 2.4 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1 -Version 2.4"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 2.4 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 2.4 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 2.4 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult


# Write-Error -ErrorAction Continue
Unregister-ScheduledTask  -TaskName "Error Handling Demo 2.5 (User)" -ErrorAction Ignore -Confirm:$false
$Splat_TaskAction = @{
    Execute  = "Powershell.exe"
    Argument = " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $(Get-Location)\Error_Demo4_Task1.ps1 -Version 2.5"
}
$Splat_RegisterTask = @{
    TaskName = "Error Handling Demo 2.5 (User)"
    TaskPath = "\"
    Action   = New-ScheduledTaskAction @Splat_TaskAction
    Setting  = New-ScheduledTaskSettingsSet -Hidden
}
Register-ScheduledTask @Splat_RegisterTask -Force
Start-ScheduledTask -TaskName "Error Handling Demo 2.5 (User)"
Start-Sleep -Seconds 3
Get-ScheduledTaskInfo -TaskName "Error Handling Demo 2.5 (User)" | Select-Object TaskName, LastRunTime, LastTaskResult
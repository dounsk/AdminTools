If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$ServiceHealthCheck = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $env:COMPUTERNAME WARNING: RERUN QS SERVICE"
$msg2 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') QS service status check triggered on: "+$env:COMPUTERNAME
$RAM_Usage1 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') RAM Usage - Before stopping the service: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100) +"%"
$ExportLog = "C:\ProgramData\admintools\Log\"+$env:COMPUTERNAME+"_QlikService_RERUN_$(Get-Date -Format 'yyyy-MM-dd.HHmm').log"
$seconds = 10
Write-Host $ServiceHealthCheck -fore red
write-output $ServiceHealthCheck >> $ExportLog
Write-Host $RAM_Usage1 -fore green
write-output $RAM_Usage1 >> $ExportLog
Write-Host $msg2 -fore green
write-output $msg2 >> $ExportLog
$Services1 = Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output $Services1 >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
$msg3 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Attempt to re-run service on: "+$env:COMPUTERNAME
$msg4 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution started - stop all QS services."
Write-Host $msg3 -fore green
write-output $msg3 >> $ExportLog
Write-Host $msg4 -fore green
write-output $msg4 >> $ExportLog
##---Stop-Service---
Stop-Service -Name QlikSenseEngineService
Stop-Service -Name QlikSensePrintingService
Stop-Service -Name QlikSenseProxyService
Stop-Service -Name QlikSenseSchedulerService
Stop-Service -Name QlikSenseServiceDispatcher
Stop-Service -Name QlikSenseRepositoryService
$msg5 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution completed - All QS services have stopped running"
Write-Host $msg5 -fore green
write-output $msg5 >> $ExportLog
$RAM_Usage3 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') RAM Usage - After stopping the service: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100) +"%"
Write-Host $RAM_Usage3 -fore green
write-output $RAM_Usage3 >> $ExportLog
$Services2 = Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') QS service status checking:" >> $ExportLog
write-output $Services2 >> $ExportLog
#---Confirm that RAM has been released---
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity Waiting -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Continue execution when RAM usage < 5%" -fore green
write-output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Continue execution when RAM usage < 5%" >> $ExportLog
$RAM_Usage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100)
while ($RAM_Usage -ge 10) #Continue execution when RAM usage drops below 5%
{
    $RAM_Usage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100)
    $msgRAM = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') RAM usage: "+ $RAM_Usage+ "%, continue execution when RAM usage < 5%. re-check in 10 seconds."
    Write-Host $msgRAM -fore green
    write-output $msgRAM >> $ExportLog
    Start-Sleep -s 10
}
##---Start-Service---
write-output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Ready to start QS service" >> $ExportLog
$msg6 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Start QS dispatcher & repository services."
Write-Host $msg6 -fore green
write-output $msg6 >> $ExportLog
Start-Service -Name QlikSenseServiceDispatcher
Start-Service -Name QlikSenseRepositoryService
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') The service has been started, checking the live log" -fore green
write-output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') The service has been started, checking the live log" >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
Start-Sleep -Seconds 15
$LiveLog = Get-ChildItem -Path C:\ProgramData\Qlik\Sense\Log\Repository\Trace -Filter *.log | Where-Object { $_.PSIsContainer -eq $false } | Measure-Object | Select-Object -ExpandProperty Count
while ($LiveLog -ge 1)
{
 
    $LiveLog=Get-ChildItem -Path C:\ProgramData\Qlik\Sense\Log\Repository\Trace -Filter *.log | Where-Object { $_.PSIsContainer -eq $false } | Measure-Object | Select-Object -ExpandProperty Count -1
    $msg7 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') The live logs has not been auto archived (logs: "+$livelog+"), re-check in 10 seconds."
    Write-Host $msg7 -fore green
    write-output $msg7 >> $ExportLog
    Start-Sleep -s 10
}
$msg8 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') The live logs has been archived. Continue execution - Start all enabled QS service"
Write-Host $msg8 -fore green
write-output $msg8 >> $ExportLog
Start-Service -Name QlikSenseEngineService
Start-Service -Name QlikSensePrintingService
Start-Service -Name QlikSenseProxyService
Start-Service -Name QlikSenseSchedulerService
$msg9 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution completed - Service start has been completed."
Write-Host $msg9 -fore green
write-output $msg9 >> $ExportLog
write-output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Please check whether the service is started normally, make sure that it is run as administrator, and the disabled service will not be started." >> $ExportLog
$Services3 = Get-Service -Name Qlik*  | Format-Table -Property Status, DisplayName
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output $Services3 >> $ExportLog
$RAM_Usage2 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Record the memory usage after the service re-runing: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100) +"%"
Write-Host $RAM_Usage2 -fore green
write-output $RAM_Usage2 >> $ExportLog
$msg0 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution finished."
Write-Host $msg0 -fore green
write-output $msg0 >> $ExportLog
$Lucky = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Good Luck ヾ(✿ﾟ▽ﾟ)ノ"
Write-Host $Lucky -fore green
write-output $Lucky >> $ExportLog
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Exit in 10 seconds" -fore green
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity Exit -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
exit
#Please contact me if there is a problem: kuichen1@lenovo.com
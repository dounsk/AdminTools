If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$ServiceHealthCheck = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $env:COMPUTERNAME WARNING: STOP QS SERVICE"
$msg1 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') QS service status check triggered on: "+$env:COMPUTERNAME
$RAM_Usage1 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') RAM Usage - Before stopping the service: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100) +"%"
$ExportLog = "\\SYPQLIKSENSE14\ServiceHealthCheck\LOG\"+$env:COMPUTERNAME+"_QlikService_STOP_$(Get-Date -Format 'yyyy-MM-dd.HHmm').log"
$Exportlist ="\\SYPQLIKSENSE14\ServiceHealthCheck\StopTaskExecutionList.csv"
Write-Host $ServiceHealthCheck -fore red
write-output $ServiceHealthCheck >> $ExportLog
write-output $ServiceHealthCheck >> $Exportlist
Write-Host $RAM_Usage1 -fore green
write-output $RAM_Usage1 >> $ExportLog
Write-Host $msg1 -fore green
write-output $msg1 >> $ExportLog
$Services1 = Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output $Services1 >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
$msg2 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution started - stop all QS services"+$env:COMPUTERNAME
Write-Host $msg2 -fore green
write-output $msg2 >> $ExportLog
##---Stop-Service---
Stop-Service -Name QlikSenseEngineService
Stop-Service -Name QlikSensePrintingService
Stop-Service -Name QlikSenseProxyService
Stop-Service -Name QlikSenseSchedulerService
Stop-Service -Name QlikSenseServiceDispatcher
Stop-Service -Name QlikSenseRepositoryService
$msg3 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution completed - All QS services have stopped running"
Write-Host $msg3 -fore green
write-output $msg3 >> $ExportLog
$RAM_Usage3 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') RAM Usage - After stopping the service: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100) +"%"
Write-Host $RAM_Usage3 -fore green
write-output $RAM_Usage3 >> $ExportLog
$Services2 = Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') QS service status checking:" >> $ExportLog
write-output $Services2 >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
$msg0 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Execution finished."
Write-Host $msg0 -fore green
write-output $msg0 >> $ExportLog
$Lucky = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Good Luck ヾ(✿ﾟ▽ﾟ)ノ"
Write-Host $Lucky -fore green
write-output $Lucky >> $ExportLog
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Exit in 10 seconds" -fore green
$seconds = 10
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity Exit -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
exit
#Please contact me if there is a problem: kuichen1@lenovo.com
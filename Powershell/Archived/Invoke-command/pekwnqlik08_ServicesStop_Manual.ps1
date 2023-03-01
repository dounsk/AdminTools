$parameters = @{
#-------------------------------
# Target Server: 
  ComputerName = "pekwnqlik08"
#-------------------------------
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{$arguments = "& '" + $myinvocation.mycommand.definition + "'"; Start-Process powershell -Verb runAs -ArgumentList $arguments; Break;}
#-------------------------------
#Set up an FTP target server, the home directory should be set in the target server's FileZilla.
$FTPServer = "10.122.36.118:22"
#Set Email Title
$MailTitle = "Manual Service Stop"
#-------------------------------
$Warning = "$env:COMPUTERNAME Qlik Sense service will stop!"
$msg2 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Service Health Check on: "+$env:COMPUTERNAME
$RAM = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> $env:COMPUTERNAME total visible memory size "+ ((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1mb).ToString('###', $CultInfo) +" GB"
$RAM_Usage1 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> RAM Usage - before the service stops: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo) 
$ExportLog = "C:\Windows\Temp\"+$env:COMPUTERNAME+"_QlikService_Stop_$(Get-Date -Format 'yyyy-MM-dd.HHmm').log"
Write-Warning $Warning; write-output $Warning >> $ExportLog
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> $MailTitle" >> $ExportLog
Write-Host $RAM -fore green; write-output $RAM >> $ExportLog
Write-Host $RAM_Usage1 -fore green; write-output $RAM_Usage1 >> $ExportLog
Write-Host $msg2 -fore green; write-output $msg2 >> $ExportLog
write-output $(Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName) >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
$msg3 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Attempt to stop service on: "+$env:COMPUTERNAME
$msg4 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Execution started - stop all QS services."
Write-Host $msg3 -fore green; write-output $msg3 >> $ExportLog
Write-Host $msg4 -fore green; write-output $msg4 >> $ExportLog
##---Stop-Service---
Stop-Service -Name Zabbix*
Write-Warning "Zabbix Monitor has been stopped."
Start-Sleep -Seconds 3
Get-Process -Name "Engine" | Stop-Process
Stop-Service -Name QlikSensePrintingService
Stop-Service -Name QlikSenseProxyService
Stop-Service -Name QlikSenseSchedulerService
Stop-Service -Name QlikSenseServiceDispatcher
Stop-Service -Name QlikSenseRepositoryService
$msg5 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Execution completed - All QS services have stopped running."
Write-Host $msg5 -fore green; write-output $msg5 >> $ExportLog
$RAM_Usage3 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Memory usage after service is stopped: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
Write-Host $RAM_Usage3 -fore green; write-output $RAM_Usage3 >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> QS service status checking:" >> $ExportLog
write-output $(Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName) >> $ExportLog
#---Confirm that RAM has been released---
1..10 |ForEach-Object { $percent = $_ * 100 / 10;Write-Progress -Activity Waiting -Status "$(10 - $_) seconds remaining..." -PercentComplete $percent;Start-Sleep -Seconds 1}
If(((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1mb) -le 256 ){$RAMthreshold = 15}else{$RAMthreshold = 8}
Write-Host "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Continue execution when RAM usage < $RAMthreshold%" -fore green
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Continue execution when RAM usage < $RAMthreshold%" >> $ExportLog
$RAM_Usage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100)
while ($RAM_Usage -ge $RAMthreshold) #Continue execution when RAM usage < $RAMthreshold%
{    $RAM_Usage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100)
    $msgRAM = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> RAM Usage: "+ $RAM_Usage.ToString('##.##', $CultInfo)+ "%. Continue execution when RAM usage < $RAMthreshold%. re-check in 10 seconds."
    Write-Host $msgRAM -fore green
    write-output $msgRAM >> $ExportLog
    1..10 |ForEach-Object { $percent = $_ * 100 / 10;Write-Progress -Activity Waiting -Status "$(10 - $_) seconds remaining..." -PercentComplete $percent;Start-Sleep -Seconds 1}
}
$msg6 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> The memory used by Qliksense has been released."
Write-Host $msg6 -fore green; write-output $msg6 >> $ExportLog
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Please check whether the service is stoped normally, and the disabled services will not be changed." >> $ExportLog
$msg0 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Execution finished."
write-output $msg0 >> $ExportLog
$Lucky = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Good Luck ヾ(✿ﾟ▽ﾟ)ノ"
write-output $Lucky >> $ExportLog
Start-Sleep -Seconds 2
#-----Archive log------
$Dir="C:\Windows\Temp\"
$username='Qlikplatform'
$password='Qlikplatform'
$WebClient = New-Object System.Net.WebClient
$FTP = "ftp://${username}:$password@$FTPServer/Nodes/$env:COMPUTERNAME/ArchivedLogs/" #FTP directory
foreach($item in (Get-ChildItem $Dir "$env:COMPUTERNAME*.log")){
Write-Host "Uploading:	$item TO $FTPServer/Nodes/$env:COMPUTERNAME/ArchivedLogs/ ..."-fore green
$URI = New-Object System.Uri($FTP+$item.Name)
$WebClient.UploadFile($URI, $item.FullName)
}
Write-Host "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Log and trigger email notifications ... " -fore green
Start-Sleep -Seconds 1
#-----Record service maintenance
$Time = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss dddd')"
$ExportLog = "C:\Windows\Temp\Qlik_SERVICE_WARNING.txt"
$ExportCsv = "C:\Windows\Temp\Qlik_SERVICE_TASKS_"+$env:COMPUTERNAME+"_$(Get-Date -Format 'yyyy-MM').csv"
#$ExportWARNING = "C:\Windows\Temp\ServiceHealthCheck\TRIGGERWARNING.log"
#$IP = (ipconfig|select-string "IPv4"|out-string).Split(":")[1] | Convert-String -Example "1.2.3.4*=1.2.3.4"
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
$RAM_Usage = "Current Memory Usage on "+$env:COMPUTERNAME+": "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
$Services = Get-Service -Name Qliks* | Format-Table -Property Status, DisplayName
#Generate monitoring logs
$MailMsg = $Time+ " | Server" + $IP +" ("+  $env:COMPUTERNAME + ") triggered Qlik service Stop task. " + "Please check the service status."
write-output $MailMsg > $ExportLog; write-output $Services >> $ExportLog ;write-output $RAM_Usage >> $ExportLog; write-output $IP >> $ExportLog; write-output $MailTitle >> $ExportLog
#Summary service rerun records
$CSVMsg = '"'+$Time+ '"'+'	' +'"'+ "$IP" + '"'+'	' +'"'+  $env:COMPUTERNAME + '"'+'	' +'"'+ $MailTitle +'"'
write-output $CSVMsg >> $ExportCsv
#-----Archive log------
$FTP = "ftp://${username}:$password@$FTPServer/WARNING/"
foreach($item in (Get-ChildItem $Dir "Qlik_SERVICE*.*")){
Write-Host "Uploading:	$item To $FTPServer/WARNING/ ..."-fore green
$URI = New-Object System.Uri($FTP+$item.Name)
$WebClient.UploadFile($URI, $item.FullName)
}
#Cleanup local temporary files
remove-item "C:\Windows\Temp\$env:COMPUTERNAME*.log" 
remove-item "C:\Windows\Temp\Qlik_SERVICE*.txt" 
Write-Host $msg0 -fore green;
Write-Host $Lucky -fore green;
1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
exit
}
}
Invoke-Command @parameters
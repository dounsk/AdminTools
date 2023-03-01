If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{$arguments = "& '" + $myinvocation.mycommand.definition + "'"; Start-Process powershell -Verb runAs -ArgumentList $arguments; Break;}

Write-Host "
██╗      ██████╗  ██████╗ █████╗ ██╗         ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗
██║     ██╔═══██╗██╔════╝██╔══██╗██║         ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝
██║     ██║   ██║██║     ███████║██║         ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  
██║     ██║   ██║██║     ██╔══██║██║         ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  
███████╗╚██████╔╝╚██████╗██║  ██║███████╗    ███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗
╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝
                                                                                                 
     ██████╗ ███╗   ██╗██╗  ██╗   ██╗██╗                                                         
    ██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝██║                                                         
    ██║   ██║██╔██╗ ██║██║   ╚████╔╝ ██║                                                         
    ██║   ██║██║╚██╗██║██║    ╚██╔╝  ╚═╝                                                         
    ╚██████╔╝██║ ╚████║███████╗██║   ██╗                                                         
     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝   ╚═╝                                                         
                                                                                                 
                                                                                                                                         
"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Localhost Qlik Sense Service Maintenance Task'
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = 'CenterScreen'


$ReRunButton = New-Object System.Windows.Forms.Button
$ReRunButton.Location = New-Object System.Drawing.Point(110,150)
$ReRunButton.Size = New-Object System.Drawing.Size(75,23)
$ReRunButton.Text = 'RERUN'
$ReRunButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $ReRunButton
$form.Controls.Add($ReRunButton)

$STOPButton = New-Object System.Windows.Forms.Button
$STOPButton.Location = New-Object System.Drawing.Point(210,150)
$STOPButton.Size = New-Object System.Drawing.Size(75,23)
$STOPButton.Text = 'STOP'
$STOPButton.DialogResult = [System.Windows.Forms.DialogResult]::NO
$form.AcceptButton = $STOPButton
$form.Controls.Add($STOPButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(310,150)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(310,45)
$listBox.Size = New-Object System.Drawing.Size(200,45)

$listBox.SelectionMode = 'MultiExtended'
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,50)
$label.Size = New-Object System.Drawing.Size(500,100)
$label.Text = "• Maintenance Qlik Sense Services on Localhost: $env:COMPUTERNAME

• RERUN = Stop all Localhost QS services then start all QS services.
• STOP   = Stop all Localhost QS services.
"
$form.Controls.Add($label)


$result = $form.ShowDialog()


if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{$arguments = "& '" + $myinvocation.mycommand.definition + "'"; Start-Process powershell -Verb runAs -ArgumentList $arguments; Break;}
#-------------------------------
#Set up an FTP target server, the home directory should be set in the target server's FileZilla.
$FTPServer = "10.122.36.118:22"
#Set Email Title
$MailTitle = "Manual Service Rerun"
#-------------------------------
$Warning = "$env:COMPUTERNAME Qlik Sense service will rerun!"
$msg2 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Service Health Check on: "+$env:COMPUTERNAME
$RAM = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> $env:COMPUTERNAME total visible memory size "+ ((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1mb).ToString('###', $CultInfo) +" GB"
$RAM_Usage1 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> RAM Usage - before the service stops: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo) 
$ExportLog = "C:\Windows\Temp\"+$env:COMPUTERNAME+"_QlikService_Rerun_$(Get-Date -Format 'yyyy-MM-dd.HHmm').log"
Write-Warning $Warning; write-output $Warning >> $ExportLog
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> $MailTitle" >> $ExportLog
Write-Host $RAM -fore green; write-output $RAM >> $ExportLog
Write-Host $RAM_Usage1 -fore green; write-output $RAM_Usage1 >> $ExportLog
Write-Host $msg2 -fore green; write-output $msg2 >> $ExportLog
write-output $(Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName) >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
$msg3 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Attempt to re-run service on: "+$env:COMPUTERNAME
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

Stop-Service -Name QlikSenseRepositoryService
$msg5 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Execution completed - All QS services have stopped running."
Write-Host $msg5 -fore green; write-output $msg5 >> $ExportLog
$RAM_Usage3 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Memory usage after service is stopped: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
Write-Host $RAM_Usage3 -fore green; write-output $RAM_Usage3 >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> QS service status checking:" >> $ExportLog
write-output $(Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName) >> $ExportLog
Start-Sleep -Seconds 5
##---Start-Service---
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Ready to start QS service." >> $ExportLog
$msg6 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Start QS dispatcher & repository services."
Write-Host $msg6 -fore green; write-output $msg6 >> $ExportLog
Start-Service -Name QlikSenseServiceDispatcher
Start-Service -Name QlikSenseRepositoryService
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
Write-Host "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Checking the live log ... " -fore green
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Checking the live log ... " >> $ExportLog
1..15 |ForEach-Object { $percent = $_ * 100 / 15;Write-Progress -Activity Waiting -Status "$(15 - $_) seconds remaining..." -PercentComplete $percent;Start-Sleep -Seconds 1}
$LiveLog = Get-ChildItem -Path C:\ProgramData\Qlik\Sense\Log\Repository\Trace -Filter *.log | Where-Object { $_.PSIsContainer -eq $false } | Measure-Object | Select-Object -ExpandProperty Count
while ($LiveLog -ge 1){
    $LiveLog=Get-ChildItem -Path C:\ProgramData\Qlik\Sense\Log\Repository\Trace -Filter *.log | Where-Object { $_.PSIsContainer -eq $false } | Measure-Object | Select-Object -ExpandProperty Count -1
    $msg7 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> The live logs has not been auto archived (logs: "+$livelog+"), Recheck after 10 seconds."
    Write-Host $msg7 -fore green
    write-output $msg7 >> $ExportLog
    1..10 |ForEach-Object { $percent = $_ * 100 / 10;Write-Progress -Activity Waiting -Status "$(10 - $_) seconds remaining..." -PercentComplete $percent;Start-Sleep -Seconds 1}
}
$msg8 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> The live logs has been archived. Continue execution - Start all enabled QS service."
Write-Host $msg8 -fore green
write-output $msg8 >> $ExportLog
Start-Service -Name QlikSenseEngineService
Start-Service -Name QlikSensePrintingService
Start-Service -Name QlikSenseProxyService
Start-Service -Name QlikSenseSchedulerService
Start-Service -Name Zabbix*
Write-Warning "Zabbix Monitor has been Restarted."
$msg9 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Execution completed - Service start has been completed."
Write-Host $msg9 -fore green; write-output $msg9 >> $ExportLog
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Please check whether the service is started normally, and the disabled services will not be changed." >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output $(Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName) >> $ExportLog
$RAM_Usage2 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Memory usage after service restart: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
Write-Host $RAM_Usage2 -fore green; write-output $RAM_Usage2 >> $ExportLog
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
$ExportWARN = "C:\Windows\Temp\Qlik_SERVICE_WARNING.txt"
# $ExportCsv = "C:\Windows\Temp\Qlik_SERVICE_TASKS_"+$env:COMPUTERNAME+"_$(Get-Date -Format 'yyyy-MM-dd').csv"
#$ExportWARNING = "C:\Windows\Temp\ServiceHealthCheck\TRIGGERWARNING.log"
#$IP = (ipconfig|select-string "IPv4"|out-string).Split(":")[1] | Convert-String -Example "1.2.3.4*=1.2.3.4"
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
$RAM_Usage = "Current Memory Usage on "+$env:COMPUTERNAME+": "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
$Services = Get-Service -Name Qliks* | Format-Table -Property Status, DisplayName
#Generate monitoring logs
$MailMsg = $Time+ " | Server" + $IP +" ("+  $env:COMPUTERNAME + ") triggered Qlik service Rerun task. " + "Please check the service running status."
write-output $MailMsg > $ExportWARN; write-output $Services >> $ExportWARN ;write-output $RAM_Usage >> $ExportWARN; write-output $IP >> $ExportWARN; write-output $MailTitle >> $ExportWARN
#Summary service rerun records
# $CSVMsg = '"'+$Time+ '"'+'	' +'"'+ "$IP" + '"'+'	' +'"'+  $env:COMPUTERNAME + '"'+'	' +'"'+ $MailTitle +'"'
# write-output $CSVMsg >> $ExportCsv
#-----Archive log------
$FTP = "ftp://${username}:$password@$FTPServer/WARNING/"
foreach($item in (Get-ChildItem $Dir "Qlik_SERVICE*.*")){
Write-Host "Uploading:	$item To $FTPServer/WARNING/ ..."-fore green
$URI = New-Object System.Uri($FTP+$item.Name)
$WebClient.UploadFile($URI, $item.FullName)
}
#Cleanup local temporary files
if((Test-Path $ExportLog) -eq "True"){Remove-Item $ExportLog;}
# if((Test-Path $ExportCsv) -eq "True"){Remove-Item $ExportCsv;}
if((Test-Path $ExportWARN) -eq "True"){Remove-Item $ExportWARN;}
Write-Host $msg0 -fore green;
Write-Host $Lucky -fore green;
#Trigger email notification 
powershell C:\ProgramData\Admintools\QsServicesEmailAlerts.ps1


1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
exit
}

if ($result -eq [System.Windows.Forms.DialogResult]::NO)
{
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
Stop-Service -Name QlikSenseRepositoryService
$msg5 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Execution completed - All QS services have stopped running."
Write-Host $msg5 -fore green; write-output $msg5 >> $ExportLog
$RAM_Usage3 = "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> Memory usage after service is stopped: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
Write-Host $RAM_Usage3 -fore green; write-output $RAM_Usage3 >> $ExportLog
Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName
write-output "<$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')> QS service status checking:" >> $ExportLog
write-output $(Get-Service -Name Qlik* | Format-Table -Property Status, DisplayName) >> $ExportLog

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
$ExportWARN = "C:\Windows\Temp\Qlik_SERVICE_WARNING.txt"
# $ExportCsv = "C:\Windows\Temp\Qlik_SERVICE_TASKS_"+$env:COMPUTERNAME+"_$(Get-Date -Format 'yyyy-MM-dd').csv"
#$ExportWARNING = "C:\Windows\Temp\ServiceHealthCheck\TRIGGERWARNING.log"
#$IP = (ipconfig|select-string "IPv4"|out-string).Split(":")[1] | Convert-String -Example "1.2.3.4*=1.2.3.4"
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
$RAM_Usage = "Current Memory Usage on "+$env:COMPUTERNAME+": "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
$Services = Get-Service -Name Qliks* | Format-Table -Property Status, DisplayName
#Generate monitoring logs
$MailMsg = $Time+ " | Server" + $IP +" ("+  $env:COMPUTERNAME + ") triggered Qlik service Stop task. " + "Please check the service status."
write-output $MailMsg > $ExportWARN; write-output $Services >> $ExportWARN ;write-output $RAM_Usage >> $ExportWARN; write-output $IP >> $ExportWARN; write-output $MailTitle >> $ExportWARN
#Summary service rerun records
# $CSVMsg = '"'+$Time+ '"'+'	' +'"'+ "$IP" + '"'+'	' +'"'+  $env:COMPUTERNAME + '"'+'	' +'"'+ $MailTitle +'"'
# write-output $CSVMsg >> $ExportCsv
#-----Archive log------
$FTP = "ftp://${username}:$password@$FTPServer/WARNING/"
foreach($item in (Get-ChildItem $Dir "Qlik_SERVICE*.*")){
Write-Host "Uploading:	$item To $FTPServer/WARNING/ ..."-fore green
$URI = New-Object System.Uri($FTP+$item.Name)
$WebClient.UploadFile($URI, $item.FullName)
}
#Cleanup local temporary files
if((Test-Path $ExportLog) -eq "True"){Remove-Item $ExportLog;}
# if((Test-Path $ExportCsv) -eq "True"){Remove-Item $ExportCsv;}
if((Test-Path $ExportWARN) -eq "True"){Remove-Item $ExportWARN;}
Write-Host $msg0 -fore green;
Write-Host $Lucky -fore green;
#Trigger email notification
powershell C:\ProgramData\Admintools\QsServicesEmailAlerts.ps1

1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
exit
}
# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyPB6I2jS1S658lq32C5ipKKb
# ycugggL6MIIC9jCCAd6gAwIBAgIQYy628oWyaJdNIAN45Kx4cDANBgkqhkiG9w0B
# AQsFADATMREwDwYDVQQDDAhLdWkuQ2hlbjAeFw0yMjA2MTcwODMzMzhaFw0yNzA2
# MTcwODQzMzhaMBMxETAPBgNVBAMMCEt1aS5DaGVuMIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEAosY00viCpPwEaUNdPRnFnmbmcP7RoOLltQz8ic2zIprh
# ZzFs8wYyOjWkBjgmiUJxMmq1bleKXM41XOBLshd2I1mgLH/Xei63ZGEhja5EO+Gh
# T6ZmK1DzKGCSMnh/eVAiKbmmJfJRwOFRE75/tw5md+Db11HQ1kTfiCMLxa3plb9+
# 7swcsSprb9c8C3F6xqacz2mJGn8iC3wMUV+T/viNSKjR9ggMIFY0XdYyfQsFelSY
# jrkM1V1Y8lumsI4IkE6nk/wjYCJ0yq44iaxKtBgok1LLwRiGuQV7onmS3ZsJctuj
# E4PORtNAgvuQjnH1hDFm1nuPwnondwgstbFYFqVOIQIDAQABo0YwRDAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFF/islvxILt2
# 5vUEq73jrGlqH4pLMA0GCSqGSIb3DQEBCwUAA4IBAQAl5pj9fw+e0LTvskcNvqSd
# 3expzaUUXNPAwOJ7IpEmzxk1glUWQV+0CmKzM22G/CqCHEXC30pwGQp82WIHbOpK
# 130dYmGK0hdr408rMF9QwFGcMH91d4DaXrFFNCu2bN473WYtk+e5REhuaVEYFNmb
# e5/2CmIOJHomP4CmKePGDTh78LxFTG8GZ6EkovDma70cXy3k60Mr5a3BruyCzysL
# 3mKY9/ET5PUwVPl33mm3BMATAMtS5dZhTfG3Sya0Jlj/XQ5zTN8zDMmdqbGcERB/
# /0CpKAFJ+iCU2odb7Nmnikg753vLRrWWgCyASi31a/IYEK0IhrYO+mFfxngvd8yl
# MYIByDCCAcQCAQEwJzATMREwDwYDVQQDDAhLdWkuQ2hlbgIQYy628oWyaJdNIAN4
# 5Kx4cDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUA/bO9GHKdVpLTmn7yRnBIcwUM6QwDQYJKoZI
# hvcNAQEBBQAEggEATfGY+/hP5eK6Si6i4X9SCSkhG5Fm8BDQ8EIHsW8qTqa/M0Ss
# fuOihTycmIRdFdEeRtZ74WLrIWK275m3juLJfNtL3GI0b0IhQI9LUcbsKuIUJqtj
# rUsM1r86y5FYxhVhTyw6SKR2ghc71WwdFNuNBOdRh01kk17fhEM3/shlZYlwX3+z
# 2XvzypQJn+KsmftmJyGPRZUZGk4PBsr1aTslr3mE838Ia2fWFP0fmLIx3/Lns6J4
# XrJHoDcDelW6jO0bSb7Bnk0gUoJTNDkHpMlbhcM1LeswY5LE48cSUOl7K0+tuZNB
# rVtyWoDWxEd06n+XsMQ8tUrsIAz2kISSaamCyw==
# SIG # End signature block

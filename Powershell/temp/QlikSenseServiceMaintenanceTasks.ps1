Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Qlik Sense Service Maintenance Task'
$form.Size = New-Object System.Drawing.Size(550,650)
$form.StartPosition = 'CenterScreen'


$ReRunButton = New-Object System.Windows.Forms.Button
$ReRunButton.Location = New-Object System.Drawing.Point(110,550)
$ReRunButton.Size = New-Object System.Drawing.Size(75,23)
$ReRunButton.Text = 'RERUN'
$ReRunButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $ReRunButton
$form.Controls.Add($ReRunButton)

$STOPButton = New-Object System.Windows.Forms.Button
$STOPButton.Location = New-Object System.Drawing.Point(210,550)
$STOPButton.Size = New-Object System.Drawing.Size(75,23)
$STOPButton.Text = 'STOP'
$STOPButton.DialogResult = [System.Windows.Forms.DialogResult]::NO
$form.AcceptButton = $STOPButton
$form.Controls.Add($STOPButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(310,550)
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
$label.Location = New-Object System.Drawing.Point(10,480)
$label.Size = New-Object System.Drawing.Size(500,40)
$label.Text = "• Do not select blank items
• Do not select currently logged in server - $env:COMPUTERNAME
"
$form.Controls.Add($label)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,40)
$label2.Size = New-Object System.Drawing.Size(300,480)
$label2.Text = 
'-PRD-
    Scheduler  1   - 10.122.36.121  - <05> :
    Scheduler  2   - 10.122.36.122  - <06> :
    Scheduler  3   - 10.122.36.123  - <07> :
    Scheduler  4   - 10.122.36.124  - <08> :
    Scheduler  5   - 10.122.36.220  - <17> :

    ProxyNode1    - 10.122.36.107  - <11> :
    ProxyNode2    - 10.122.36.108  - <12> :
    ProxyNode3    - 10.122.36.109  - <13> :
    ProxyNode4    - 10.122.36.100  - <15> :
    ProxyNode5    - 10.122.36.106  - <18> :

    API Node 1      - 10.122.36.119  - <03> :
    API Node 2      - 10.122.36.110  - <04> :
    QS NPrinting   - 10.122.36.130  - <19> :



-DEV-
    Scheduler  1   - 10.122.36.112  - <06> :
    Scheduler  2   - 10.122.36.128  - <09> :

    ProxyNode1    - 10.122.36.114  - <01> :
    ProxyNode2    - 10.122.36.115  - <03> :
    ProxyNode3    - 10.122.36.116  - <04> :



-TST-
    CentralNode   - 10.122.27.37  - <07> :
    ProxyNode     - 10.122.27.38  - <08> :

'
$form.Controls.Add($label2)

[void] $listBox.Items.Add('sypqliksense05')
[void] $listBox.Items.Add('sypqliksense06')
[void] $listBox.Items.Add('sypqliksense07')
[void] $listBox.Items.Add('sypqliksense08')
[void] $listBox.Items.Add('sypqliksense17')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('sypqliksense11')
[void] $listBox.Items.Add('sypqliksense12')
[void] $listBox.Items.Add('sypqliksense13')
[void] $listBox.Items.Add('sypqliksense15')
[void] $listBox.Items.Add('sypqliksense18')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('sypqliksense03')
[void] $listBox.Items.Add('sypqliksense14')
[void] $listBox.Items.Add('sypqliksense19')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('pekwpqlik06')
[void] $listBox.Items.Add('sypqliksense09')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('pekwpqlik01')
[void] $listBox.Items.Add('pekwpqlik03')
[void] $listBox.Items.Add('pekwpqlik04')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('PEKWNQLIK07')
[void] $listBox.Items.Add('PEKWNQLIK08')
$listBox.Height = 410
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $ComputerName = $listBox.SelectedItems

    if($ComputerName -contains "")
    {
    Write-Host " "
    Write-Warning "Invalid selection!"
    Write-Warning "Your selection contains blank items."
    Write-Warning "Please select only the hostname that needs maintenance!"
    Start-Sleep -Seconds 10
    exit
    }

    if($ComputerName -contains $env:COMPUTERNAME)
    {
    Write-Host " "
    Write-Warning "Invalid selection!"
    Write-Warning "Your selection contains currently logged in server: $env:COMPUTERNAME"
    Write-Warning "Please select the hostname to remotely manage the Qlik service"
    Start-Sleep -Seconds 10
    exit
    }

   Add-Type -AssemblyName  System.Windows.Forms
$message = "Trigger the Qlik service RERUN task on node:
"+$ComputerName+"
Continue?"
$title = '[WARNING] Action confirmation'
$Buttons = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
if($Buttons -eq "Yes")
{
  
  $parameters = @{
#-------------------------------
# Target Server: 
  ComputerName = $ComputerName
#-------------------------------
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {
  
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

#Trigger email notification
powershell C:\ProgramData\Admintools\QsServicesEmailAlerts.ps1

Write-Host $msg0 -fore green;
Write-Host $Lucky -fore green;
1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
exit

}
}
Invoke-Command @parameters 

}
}

if ($result -eq [System.Windows.Forms.DialogResult]::NO)
{
    
    $ComputerName = $listBox.SelectedItems

    if($ComputerName -contains "")
    {
    Write-Host " "
    Write-Warning "Invalid selection!"
    Write-Warning "Your selection contains blank items."
    Write-Warning "Please select only the hostname that needs maintenance!"
    Start-Sleep -Seconds 10
    exit
    }

    if($ComputerName -contains $env:COMPUTERNAME)
    {
    Write-Host " "
    Write-Warning "Invalid selection!"
    Write-Warning "Your selection contains currently logged in server: $env:COMPUTERNAME"
    Write-Warning "Please select the hostname to remotely manage the Qlik service."
    Start-Sleep -Seconds 10
    exit
    }

   Add-Type -AssemblyName  System.Windows.Forms
$message = "Trigger the Qlik service STOP task on node:
"+$ComputerName+"
Continue?"
$title = '[WARNING] Action confirmation'
$Buttons = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
if($Buttons -eq "Yes")
{
  
  $parameters = @{
#-------------------------------
# Target Server: 
  ComputerName = $ComputerName
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

#Trigger email notification
powershell C:\ProgramData\Admintools\QsServicesEmailAlerts.ps1

Write-Host $msg0 -fore green;
Write-Host $Lucky -fore green;
1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
exit

}
}
Invoke-Command @parameters 
}
}

# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPlhxGA+180/CrYWAP8h3mKzu
# 4NOgggL6MIIC9jCCAd6gAwIBAgIQbOcAbxhhm4NP1NxHLG9EKzANBgkqhkiG9w0B
# AQsFADATMREwDwYDVQQDDAhLdWkuQ2hlbjAeFw0yMjA2MTUwOTIzMTNaFw0yNzA2
# MTUwOTMzMTRaMBMxETAPBgNVBAMMCEt1aS5DaGVuMIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEA1ZfWyYSSoxhT0gdk5uIWf/qO2TnKC18a1vrORt3CGCLy
# yyY/MwrwxcklNZFfETcXBnTQkp/WakBlDBV8W5kdjm3U7QPzYf/PxrpXNeDvXK59
# tLzZ39TJ24EorLXcrUtf3XZXsWAMWzbUetnCHoRaqQQGjb6oAlT9EonLiw7zz6Wd
# T6uirVf2XvykRNPjXwLP0ZDez/aqYS6PLLOtzpC4RPbMGWqWw+1+4ywYqahDGBp1
# gOji9LbxXFdqHvYGDsKaPculFaV8UDr7vCcOyt0C/EQrfxmOKAK5nfzwBd9yrBF6
# eB+scgv4D+BKNmxs3dD6mLlA3s2dsMFJ9ndPaZC8nQIDAQABo0YwRDAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFEWDyVEJetr9
# ydGoxfL2gLUWBe8TMA0GCSqGSIb3DQEBCwUAA4IBAQAkVxF5SyCA0dS6WKYnS5V7
# cZ1OVUI7J4Q39n4mkmlNjrnWA5QDAdhls4mchcHz9EF2iQSfpD1Bx1xeGcDw6r5u
# ExdNpZlXl+NHi7WqNA9ZJrFI/0xx7UQFPdCv3Dk4vLMOOffxg4wLSJwu/j7DqDYQ
# 918ZXFL4fprH7XTVrn3OVJGkeksQ7MdqTSVWlL8/UL87+Zo0yQqpteIxX/Q7TsPf
# MTSV29Qb/UP4tsH8EK+0UJI5pHQnzrEPSSbXveSV4s1YblYlD2FYiF6Tez/u5UIO
# XLuJw1WLKukVh+VvuUDPVUOmPERwFMUMrWqjv3uYh1w1dkNjG2+4buzHp+olMCw4
# MYIByDCCAcQCAQEwJzATMREwDwYDVQQDDAhLdWkuQ2hlbgIQbOcAbxhhm4NP1NxH
# LG9EKzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUXkN/GrhQAegzkBL7J/hwZOOUbCkwDQYJKoZI
# hvcNAQEBBQAEggEAWgy+jBsyRRIWyE1y6UjangcYxo9InJrtvsAPDQdu5uw4hpiX
# w66yjMK30xIuPLfBrj+ec9mdfGVLhLlZBE++7V/vMUZDYQFfFlUGM1lgTGJC3jUS
# pWN1Z50e4GKZHBy56ZbKUpzH52VPyUPzB2UlBRjNyfjappxK+pBPI+F7wnhsjJyt
# zstDtkl3EG/rQFDl4ig94kisyTpNdj4vACp6FOT2FMQDSinPhrEjQmOFtR/radw+
# mKVao+bQZAVn9pknd4znYlQlOD0sf8Frjm5jYbqnP+Yu7xpBsbz9aI4FCTtSlRxM
# oLE301+D6+DZbAKM6vYTUBwdNdZtXd9/GmPT+A==
# SIG # End signature block

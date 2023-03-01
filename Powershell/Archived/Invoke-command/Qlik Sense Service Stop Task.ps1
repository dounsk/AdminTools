Enum ShowStates
{
  Hide = 0
  Normal = 1
  Minimized = 2
  Maximized = 3
  ShowNoActivateRecentPosition = 4
  Show = 5
  MinimizeActivateNext = 6
  MinimizeNoActivate = 7
  ShowNoActivate = 8
  Restore = 9
  ShowDefault = 10
  ForceMinimize = 11
}

$code = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$type = Add-Type -MemberDefinition $code -Name myAPI -PassThru
$process = Get-Process -Id $PID
$hwnd = $process.MainWindowHandle
$type::ShowWindowAsync($hwnd, [ShowStates]::Hide)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Qlik Sense Service Rerun Task'
$form.Size = New-Object System.Drawing.Size(550,550)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(175,450)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(265,450)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please make a selection from the nodes list below:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(260,45)
$listBox.Size = New-Object System.Drawing.Size(250,45)

$listBox.SelectionMode = 'MultiExtended'

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,40)
$label2.Size = New-Object System.Drawing.Size(250,380)
$label2.Text = 
'--- PRD ---
    Scheduler  1   - 10.122.36.121  - <05> :
    Scheduler  2   - 10.122.36.122  - <06> :
    Scheduler  3   - 10.122.36.123  - <07> :
    Scheduler  4   - 10.122.36.124  - <08> :
    Scheduler  5   - 10.122.36.220  - <17> :
	
    ProxyEngine1 - 10.122.36.107  - <11> :
    ProxyEngine2 - 10.122.36.108  - <12> :
    ProxyEngine3 - 10.122.36.109  - <13> :
    ProxyEngine4 - 10.122.36.100  - <15> :
    ProxyEngine5 - 10.122.36.106  - <18> :
	
    A P I 1             -  10.122.36.119  - <03> :
    A P I 2             -  10.122.36.110  - <04> :
	
    Sense _ NP     - 10.122.36.130  - <19> :
    CentralMaster - 10.122.36.120  - <04> :


--- DEV ---
    CentralMaster - 10.122.36.111  - <05> :

    Scheduler  1   - 10.122.36.112  - <06> :
    Scheduler  2   - 10.122.36.128  - <09> :

    ProxyEngine1 - 10.122.36.114  - <01> :
    ProxyEngine2 - 10.122.36.115  - <03> :
    ProxyEngine3 - 10.122.36.116  - <04> :

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
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('sypqliksense19')
[void] $listBox.Items.Add('sypqliksense04')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add(' - - - ')
[void] $listBox.Items.Add('pekwpqlik05')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('pekwpqlik06')
[void] $listBox.Items.Add('sypqliksense09')
[void] $listBox.Items.Add('')
[void] $listBox.Items.Add('pekwpqlik01')
[void] $listBox.Items.Add('pekwpqlik03')
[void] $listBox.Items.Add('pekwpqlik04')

$listBox.Height = 380
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $ComputerName = $listBox.SelectedItems
    
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

}
}
# SIG # Begin signature block
# MIIFWAYJKoZIhvcNAQcCoIIFSTCCBUUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4Rba4S/7EZSgesTr+pqJe/FV
# nW6gggL6MIIC9jCCAd6gAwIBAgIQbOcAbxhhm4NP1NxHLG9EKzANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUHOvrHGJMw1J9xEwKZNTRO4mt5J0wDQYJKoZI
# hvcNAQEBBQAEggEAbPpMYCkR6rFzc3HBnfiejfijMVa/c97k7g8e4tyKIDsDtuP8
# YhDE7/Ph/BU9XeQj4sdKh9pKBFBIKdCv/Sqczq3aBr0ccZQ4O+BcKvJPC1kY/Bz6
# RQIn6eYKxvnnvqs3/CRlxugRBtjSMN573PCnbQAngQITwhg5YFOX/YZm+VlYzZhq
# 2mhggeQYFBl+ehbZeQV30PgG/w6rcRlIZL/XqIh62R55QITn17V7KM6Unpucryg/
# WiDDmgUTv6pjaOz0A9yOjauvf7Ui7qBCGLtkXaR8PmeZTO6bLD3NWL07pP0Ro9ny
# CUnsrOMald1qySlkS+gBVwVFeZbthdmafZw8hg==
# SIG # End signature block

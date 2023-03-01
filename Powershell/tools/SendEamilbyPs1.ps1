<#
 Author: Kui.Chen
 Date: 2023-02-17 09:58:58
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-17 10:06:20
 FilePath: \Scripts\Powershell\tools\SendEamilbyPs1.ps1
 Description: 使用Powershell 发送邮件 Send-MailMessage
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>

<#
NAME
    Send-MailMessage

SYNTAX
    Send-MailMessage [-To] <string[]> [-Subject] <string> [[-Body] <string>] [[-SmtpServer] <string>] -From <string> [-Attachments <string[]>] [-Bcc <string[]>] [-BodyAsHtml] [-Encoding <Encoding>] [-Cc <str 
    ing[]>] [-DeliveryNotificationOption {None | OnSuccess | OnFailure | Delay | Never}] [-Priority {Normal | Low | High}] [-Credential <pscredential>] [-UseSsl] [-Port <int>]  [<CommonParameters>]
#>

# 设置SMTP和邮件发送信息
$smtpServer = 'Smtpinternal.lenovo.com'
$from = 'qlikplatform@lenovo.com'
$password = 'CgFU-2202'
# 设置收件人
$to = 'kuichen1@lenovo.com','kuichen1@lenovo.com'

# 设置邮件标题
$MailTitle = "API Service Rerun"
$subject = '[' + $MailTitle + '] ' + $IP + ' QS Service Maintenance Is Triggered'
# 设置邮件正文
$Time = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss dddd')"
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
$RAM_Usage = "Current Memory Usage: "+ ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo)
# 使用HTML邮件格式
$body = @"
<html>
<body>
<p>IP:    $IP</p>
<p>Date:    $Time</p>
<p>Notes:    $env:COMPUTERNAME triggered Qlik service Rerun task. Please check the service running status. $RAM_Usage</p>
<p> </p>
<p></p>
</body>
</html>
"@

# 1. 从本地计算机直接发送邮件

# Send-MailMessage -SmtpServer $smtpServer -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList $from, (ConvertTo-SecureString -String $password -AsPlainText -Force)) -UseSsl -Priority High

# 2. 使用远程计算机发送邮件
$AlertMessages = Send-MailMessage -SmtpServer $smtpServer -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList $from, (ConvertTo-SecureString -String $password -AsPlainText -Force)) -UseSsl -Priority High

$credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
Invoke-Command -ComputerName "SYPQLIKSENSE18" -Credential $credential -ScriptBlock { $AlertMessages } -ArgumentList $AlertMessages # -ArgumentList 携带参数执行

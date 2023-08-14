<#
 Author: Kui.Chen
 Date: 2023-02-17 18:09:26
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-24 13:56:22
 FilePath: \Scripts\Powershell\tools\QsServicesEmailAlerts.ps1
 Description: Qlik 服务告警邮件，由邮件告警服务器检查本机资源使用和启用的Qlik服务状态
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>

<#
                        _oo0oo_
                       o8888888o
                       88" . "88
                       (| -_- |)
                       0\  =  /0
                     ___/`---'\___
                   .' \\|     |// '.
                  / \\|||  :  |||// \
                 / _||||| -:- |||||- \
                |   | \\\  - /// |   |
                | \_|  ''\---/''  |_/ |
                \  .-\__  '-'  ___/-. /
              ___'. .'  /--.--\  `. .'___
           ."" '<  `.___\_<|>_/___.' >' "".
          | | :  `- \`.;`\ _ /`;.`/ - ` : | |
          \  \ `_.   \_ __\ /__ _/   .-` /  /
      =====`-.____`.___ \_____/___.-`___.-'=====
                        `=---='
 
 
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
            佛祖保佑     永不宕机     永无BUG
#>

# 获取本机机器名通知邮件告警服务器本机服务异常
$Hostname = $env:COMPUTERNAME

# 定义三个服务告警服务器，确保告警可以被正常发送
$IPs = "10.122.36.183","10.122.36.184","10.122.36.130"
foreach ($IP in $IPs) {
    if (Test-Connection -ComputerName $IP -Count 1 -Quiet) {
        $EmailAlertServer = [System.Net.Dns]::GetHostByAddress($IP).HostName
        break
    }
}

$NodeTable = @{
    "sypqliksense03" = "PRD API";
    "sypqliksense14" = "PRD API 2";
    "sypqliksense11" = "PRD Proxy Engine 1";
    "sypqliksense12" = "PRD Proxy Engine 2";
    "sypqliksense13" = "PRD Proxy Engine 3";
    "sypqliksense15" = "PRD Proxy Engine 4";
    "sypqliksense18" = "PRD Proxy Engine 5";
    "sypqliksense04" = "PRD Central Master & Scheduler Master";
    "sypqliksense06" = "PRD Central Candidate & Scheduler 1";
    "sypqliksense07" = "PRD Scheduler 2";
    "sypqliksense08" = "PRD Scheduler 3";
    "sypqliksense17" = "PRD Scheduler 4";
    "sypqliksense05" = "PRD Scheduler 5";
    "sypqliksense19" = "PRD Sense NPrinting";
    "pekwpqlik05" = "DEV Central Master & Scheduler Master";
    "pekwpqlik06" = "DEV Central Candidate & Scheduler 1";
    "pekwpqlik01" = "DEV Proxy Engine 1";
    "pekwpqlik03" = "DEV Proxy Engine 2";
    "pekwpqlik04" = "DEV Proxy Engine 3";
    "sypqliksense09" = "DEV Scheduler 2";
}

$Time = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss dddd')"
$cpuUsage = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average
$memoryUsage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo) 
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
# 获取启用的Qlik服务状态
$services = Get-Service | Where-Object {$_.Name -like "Qlik*"} | Where-Object {$_.StartType -ne "Disabled"}
# 设置邮件正文
$emailBody = @"
<table align='Center' width='800' border='0'>
<tr><td>
<p align='Center'><b>$Time</b></p>
<p align='left'>Node $env:COMPUTERNAME triggered service restart, please pay attention to resource usage and service running status, thank you.</p>
<ul>
<li>IP Address:<b>$IP</b></li>
<li>Node Role:<b>$($NodeTable[$env:COMPUTERNAME])</b></li>
<li>CPU Usage:<b>$($cpuUsage.Average)%</b></li>
<li>Memory Usage:<b>$memoryUsage</b></li>
</ul>
<br>
<table align='Center' width='400' border='1'>
<caption>Qlik Sense Service [Enabled]</caption>
<tr>
<th align='left'>Service Name</th>
<th align='left'>Status</th>
</tr>
"@
foreach ($service in $services) {
    $emailBody += @"
<tr>
<td align='left'>$($service.Name)</td>
<td><b>$($service.Status)</b></td>
</tr>
"@
}
$emailBody += @"
</table>
<br>
<i>This email is automatically sent by admintools and admin of the Qlik platform will be notified of changes in the status of the service. 
Please don't reply, thanks.</i><br>
</td></tr>
<br>
</table>
"@

# 远程通知告警服务器本机故障
$credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
Invoke-Command -ComputerName $EmailAlertServer -Credential $credential -ScriptBlock {
    # Send email
    $emailSubject = $Using:Hostname + " Qlik Service Maintenance is Triggered"
    $smtpTo = "qlikplatform@lenovo.com","maxx1@lenovo.com","kuichen1@lenovo.com","zhangzh42@lenovo.com"
    # $smtpTo = "kuichen1@lenovo.com"
    $smtpServer = "Smtpinternal.lenovo.com"
    $smtpFrom = "qlikplatform@lenovo.com"
    $password = 'CgFU-2202'
    Send-MailMessage -SmtpServer $smtpServer -From $smtpFrom -To $smtpTo -Subject $emailSubject -Body $Using:emailBody -BodyAsHtml -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList $smtpFrom, (ConvertTo-SecureString -String $password -AsPlainText -Force)) -UseSsl -Priority High

 } -ArgumentList $Hostname, $emailBody
<#
 Author: Kui.Chen
 Date: 2023-02-17 18:09:26
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-24 14:01:48
 FilePath: \Scripts\Powershell\tools\EngineCrashNotification.ps1
 Description: Email Alerts for Qlik Engine Service 
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
    "sypqliksense03" = "[PRD] API 01";
    "sypqliksense14" = "[PRD] API 02";
    "sypqliksense11" = "[PRD] Proxy Engine 01";
    "sypqliksense12" = "[PRD] Proxy Engine 02";
    "sypqliksense13" = "[PRD] Proxy Engine 03";
    "sypqliksense15" = "[PRD] Proxy Engine 04";
    "sypqliksense18" = "[PRD] Proxy Engine 05";
    "sypqliksense04" = "[PRD] Central Master & Scheduler Master";
    "sypqliksense06" = "[PRD] Central Candidate & Scheduler 01";
    "sypqliksense07" = "[PRD] Scheduler 02";
    "sypqliksense08" = "[PRD] Scheduler 03";
    "sypqliksense17" = "[PRD] Scheduler 04";
    "sypqliksense05" = "[PRD] Scheduler 05";
    "sypqliksense19" = "[PRD] Sense NPrinting";
    "pekwpqlik05" = "[DEV] Central Master & Scheduler Master";
    "pekwpqlik06" = "[DEV] Central Candidate & Scheduler 01";
    "pekwpqlik01" = "[DEV] Proxy Engine 01";
    "pekwpqlik03" = "[DEV] Proxy Engine 02";
    "pekwpqlik04" = "[DEV] Proxy Engine 03";
    "sypqliksense09" = "[DEV] Scheduler 02";
}

$Time = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss dddd')"
$cpuUsage = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average
$memoryUsage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo) 
$IP = (((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0]
# 获取启用的Qlik服务状态
$services = Get-Service | Where-Object {$_.Name -like "Qlik*"} | Where-Object {$_.StartType -ne "Disabled"}
# 设置邮件正文
$emailBody = "<table align='Center' width='800' border='0'>"
$emailBody += "<tr><td>"
$emailBody += "<p align='Center'><b>Engine Crashed at $Time</b></p>"
$emailBody += "<p align='left'> The Qlik Sense Engine service for node $env:COMPUTERNAME is crashing and the service is about to restart, 
please pay attention to the server's resource usage and service status.</p>"
$emailBody += "<ul>"
$emailBody += "<li>IP Address:<b>  $IP</b></li>"
$emailBody += "<li>Node Role:<b> $($NodeTable[$env:COMPUTERNAME]) </b></li>"
$emailBody += "<li>CPU Usage:<b> $($cpuUsage.Average)%</b></li>"
$emailBody += "<li>Memory Usage:<b> $memoryUsage </b></li>"
$emailBody += "</ul>"
$emailBody += "<table align='Center' width='400' border='1'>"
$emailBody += "<caption>Qlik Sense Service [Enabled]</caption>"
$emailBody += "<tr> <th align='left'>Service Name</th> <th align='left'>Status</th> </tr>"
foreach ($service in $services) {
    $emailBody += "<tr>"
    $emailBody += "<td align='left'>$($service.Name) </td>"
    $emailBody +="<td><b>$($service.Status)</b></td>"
    $emailBody += "</tr>"
}
$emailBody += "</table>"
$emailBody += "<br>"
$emailBody += "Windows Event Log: <br>"
# 获取一天内 Engine 服务系统故障日志
Get-EventLog -LogName application -EntryType Error -After (Get-Date).AddDays(-1) | Where-Object {$_.Source -eq "engine"} | ForEach-Object {
    $emailBody += "<b>$($_.TimeGenerated)</b> $($_.Message) </p>"
    $emailBody += "<br>"
}
$emailBody += "<br>"
$emailBody += "<i>This email is automatically sent by admintools and admin of the Qlik platform will be notified of changes in the status of the service. 
Please don't reply, thanks.</i><br>"
$emailBody += "</td></tr>"
$emailBody += "</table>"

# 远程通知告警服务器本机故障
$credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
Invoke-Command -ComputerName $EmailAlertServer -Credential $credential -ScriptBlock { # On EmailAlertServer
    
    $credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
    Invoke-Command -ComputerName $Using:Hostname -Credential $credential -ScriptBlock { # on Localhost
            # 执行重启Engine服务
            Restart-Service -Name "QlikSenseEngineService"
        }
    # Send email
    $emailSubject = $Using:Hostname + " Qlik Sense Engine Service Crashed"
    # $smtpTo = "qlikplatform@lenovo.com","maxx1@lenovo.com","kuichen1@lenovo.com","zhangzh42@lenovo.com"
    $smtpTo = "kuichen1@lenovo.com"
    $smtpServer = "Smtpinternal.lenovo.com"
    $smtpFrom = "qlikplatform@lenovo.com"
    $password = 'CgFU-2202'
    Send-MailMessage -SmtpServer $smtpServer -From $smtpFrom -To $smtpTo -Subject $emailSubject -Body $Using:emailBody -BodyAsHtml -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList $smtpFrom, (ConvertTo-SecureString -String $password -AsPlainText -Force)) -UseSsl -Priority High

} -ArgumentList $Hostname, $emailBody
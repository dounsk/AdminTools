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
$IPs = "10.122.36.183", "10.122.36.184", "10.122.36.130"
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
    "pekwpqlik05"    = "[DEV] Central Master & Scheduler Master";
    "pekwpqlik06"    = "[DEV] Central Candidate & Scheduler 01";
    "pekwpqlik01"    = "[DEV] Proxy Engine 01";
    "pekwpqlik03"    = "[DEV] Proxy Engine 02";
    "pekwpqlik04"    = "[DEV] Proxy Engine 03";
    "sypqliksense09" = "[DEV] Scheduler 02";
}

$Time = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss dddd')"
$cpuUsage = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average
$memoryUsage = ((((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize - (Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory) / (Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)).ToString('#0.## %', $CultInfo) 
$IP = (((ipconfig | select-string "IPv4" | out-string).Split(":")[1]) -split '\r?\n')[0]
# 获取启用的Qlik服务状态
$services = Get-Service | Where-Object { $_.Name -like "Qlik*" } | Where-Object { $_.StartType -ne "Disabled" }
# 设置邮件正文

$emailBody = @"
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">

<head>
  <title> Hello world </title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style type="text/css">
    #outlook a {
      padding: 0;
    }

    body {
      margin: 0;
      padding: 0;
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }
    img {
      border: 0;
      height: auto;
      line-height: 100%;
      outline: none;
      text-decoration: none;
      -ms-interpolation-mode: bicubic;
    }

    p {
      display: block;
      margin: 13px 0;
    }
  </style>
  <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" rel="stylesheet" type="text/css">
  <style type="text/css">
    @import url(https://fonts.googleapis.com/css?family=Roboto:300,400,500,700);
  </style>
  <style type="text/css">
    @media only screen and (min-width:480px) {
      .mj-column-per-70 {
        width: 70% !important;
        max-width: 70%;
      }

      .mj-column-per-100 {
        width: 100% !important;
        max-width: 100%;
      }

      .mj-column-per-60 {
        width: 60% !important;
        max-width: 60%;
      }

      .mj-column-per-65 {
        width: 65% !important;
        max-width: 65%;
      }
    }
  </style>
  <style media="screen and (min-width:480px)">
    .moz-text-html .mj-column-per-70 {
      width: 70% !important;
      max-width: 70%;
    }

    .moz-text-html .mj-column-per-100 {
      width: 100% !important;
      max-width: 100%;
    }

    .moz-text-html .mj-column-per-60 {
      width: 60% !important;
      max-width: 60%;
    }

    .moz-text-html .mj-column-per-65 {
      width: 65% !important;
      max-width: 65%;
    }
  </style>
  <style type="text/css">
  </style>
</head>

<body style="word-spacing:normal;">
  <div style="">
    <div style="background:#9B9B9B;background-color:#9B9B9B;margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#9B9B9B;background-color:#9B9B9B;width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:10px;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div style="margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:0px;text-align:center;">
              <div class="mj-column-per-70 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="center" style="font-size:0px;padding:20px;word-break:break-word;">
                        <div style="font-family:Roboto, Helvetica, sans-serif;font-size:24px;font-weight:500;line-height:24px;text-align:center;color:#5FA91D;">Qlik Sense Engine Service Crashed</div>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <p style="border-top:solid 1px #616161;font-size:1px;margin:0px auto;width:100%;">
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <p style="border-top:solid 1px #616161;font-size:1px;margin:0px auto;width:45%;">
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
"@
$emailBody += '<div style="font-family:Roboto, Helvetica, sans-serif;font-size:11px;font-weight:300;line-height:24px;text-align:center;color:#9B9B9B;">' + $Time + '</div>'
$emailBody += @"
</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div style="margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:0px;text-align:center;">
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <div style="font-family:Roboto, Helvetica, sans-serif;font-size:16px;font-weight:300;line-height:24px;text-align:left;color:#616161;">
"@
$emailBody += "<p>Hi Team!</p> <p> The Qlik Sense Engine service for node $env:COMPUTERNAME is crashing and the service is about to restart, please pay attention to the server's resource usage and service status. </p>"
$emailBody += @"
</div>
</td>
</tr>
</tbody>
</table>
</div>
</td>
</tr>
</tbody>
</table>
</div>
<div style="margin:0px auto;max-width:600px;">
<table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
<tbody>
<tr>
<td style="direction:ltr;font-size:0px;padding:0px;text-align:center;">
<div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
<table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
<tbody>
<tr>
<td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
  <p style="border-top:solid 1px #E0E0E0;font-size:1px;margin:0px auto;width:100%;">
  </p>
</td></tr></table><![endif]-->
</td>
</tr>
<tr>
<td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
  <div style="font-family:Roboto, Helvetica, sans-serif;font-size:16px;font-weight:300;line-height:24px;text-align:left;color:#616161;">
    <h3 style="font-weight: bold; margin-top: 0; margin-bottom: 0"> Node Info: </h3>
  </div>
</td>
</tr>
</tbody>
</table>
</div>
</td>
</tr>
</tbody>
</table>
</div>
<div style="margin:0px auto;max-width:600px;">
<table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
<tbody>
<tr>
<td style="direction:ltr;font-size:0px;padding:0px;text-align:center;">
<div class="mj-column-per-60 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
<table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
<tbody>
<tr>
<td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
  <div style="font-family:Roboto, Helvetica, sans-serif;font-size:14px;font-weight:300;line-height:24px;text-align:left;color:#637381;">
    <ul>
"@
$emailBody += '<li style="padding-bottom: 1px">IP Address: <strong>' + $IP + '</strong> </li>'
$emailBody += '<li style="padding-bottom: 1px">Node Role: <strong>' + $($NodeTable[$env:COMPUTERNAME]) + '</strong> </li>'
$emailBody += '<li style="padding-bottom: 1px">CPU Usage: <strong>' + $($cpuUsage.Average) + '% </strong> </li>'
$emailBody += '<li style="padding-bottom: 1px">Memory Usage:: <strong>' + $memoryUsage + '</strong> </li>'

$emailBody += @"
</ul>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div style="margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:0px;text-align:center;">
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <p style="border-top:solid 1px #E0E0E0;font-size:1px;margin:0px auto;width:100%;">
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <div style="font-family:Roboto, Helvetica, sans-serif;font-size:16px;font-weight:300;line-height:24px;text-align:left;color:#616161;">
                          <h3 style="font-weight: bold; margin-top: 0; margin-bottom: 0"> Service Status: </h3>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

<table align='Center' width='65%' border='1'>
<caption>Qlik Sense Service [Enabled]</caption>
<tr> <th align='left'>Service Name</th> <th align='left'>Status</th> </tr>

"@

foreach ($service in $services) {
    $emailBody += "<tr>"
    $emailBody += "<td align='left'>$($service.Name) </td>"
    $emailBody += "<td><b>$($service.Status)</b></td>"
    $emailBody += "</tr>"
}

$emailBody += @"
</table>
</div>
<div style="margin:0px auto;max-width:600px;">
<table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
  <tbody>
    <tr>
      <td style="direction:ltr;font-size:0px;padding:0px;text-align:center;">
        <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
          <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
            <tbody>
              <tr>
                <td align="left" style="font-size:0px;padding:10px 25px;padding-bottom:0px;word-break:break-word;">
                  <div style="font-family:Roboto, Helvetica, sans-serif;font-size:16px;font-weight:300;line-height:24px;text-align:left;color:#616161;">
                    <h3 style="font-weight: bold"> Windows Event Log: </h3>
                  </div>
                </td>
              </tr>
              <tr>
                <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                  <div style="font-family:Roboto, Helvetica, sans-serif;font-size:16px;font-weight:300;line-height:24px;text-align:left;color:#616161;">
"@

# 获取一天内 Engine 服务系统故障日志
Get-EventLog -LogName application -EntryType Error -After (Get-Date).AddDays(-1) | Where-Object { $_.Source -eq "engine" } | ForEach-Object {
    $emailBody += '<p style="font-size: 14px;"><b>' + $($_.TimeGenerated) + ' </b> ' + $($_.Message) + '</p>'
}
$emailBody += @"
<div style="margin:0px auto;max-width:600px;">
<table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
  <tbody>
    <tr>
      <td style="direction:ltr;font-size:0px;padding:10px 0 20px 0;text-align:center;">
        <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
          <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
            <tbody>
              <tr>
                <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                  <p style="border-top:solid 2px #616161;font-size:1px;margin:0px auto;width:100%;">
                  </p>
                </td>
              </tr>
              <tr>
                <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                  <div style="font-family:Roboto, Helvetica, sans-serif;font-size:11px;font-weight:300;line-height:24px;text-align:center;color:#9B9B9B;"><a href="#" style="color: #9B9B9B;"></a><i> This email is from an unmonitored mailbox. <br />You are receiving this email because you have been identified as a key user associated with this service.<br /> If you have received this email in error, please notify us and delete this email permanently.</i><br /></div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </td>
    </tr>
  </tbody>
</table>
</div>
</div>
</body>
</html>
"@

# 远程通知告警服务器本机故障
$credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
Invoke-Command -ComputerName $EmailAlertServer -Credential $credential -ScriptBlock { # On EmailAlertServer
    
    # $credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
    # Invoke-Command -ComputerName $Using:Hostname -Credential $credential -ScriptBlock { # on Localhost
    #         # 执行重启Engine服务
    #         Restart-Service -Name "QlikSenseEngineService"
    #     }
    # Send email
    $emailSubject = $Using:Hostname + " Qlik Sense Engine Service Crashed"
    # $smtpTo = "qlikplatform@lenovo.com","maxx1@lenovo.com","kuichen1@lenovo.com","zhangzh42@lenovo.com"
    $smtpTo = "kuichen1@lenovo.com"
    $smtpServer = "Smtpinternal.lenovo.com"
    $smtpFrom = "qlikplatform@lenovo.com"
    $password = 'CgFU-2202'
    Send-MailMessage -SmtpServer $smtpServer -From $smtpFrom -To $smtpTo -Subject $emailSubject -Body $Using:emailBody -BodyAsHtml -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList $smtpFrom, (ConvertTo-SecureString -String $password -AsPlainText -Force)) -UseSsl -Priority High

} -ArgumentList $Hostname, $emailBody
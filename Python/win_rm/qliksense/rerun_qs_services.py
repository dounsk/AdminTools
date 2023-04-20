'''
Author       : Kui.Chen
Date         : 2023-03-13 11:46:20
LastEditors  : Kui.Chen
LastEditTime : 2023-04-19 17:45:54
FilePath     : \Scripts\Python\win_rm\qliksense\rerun_qs_services.py
Description  : 批量重启 Qlik Sense 服务
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import winrm
import datetime

def remote_server(remote_host, command): 
    remote_username = 'tableau'
    remote_password = 'wixj-2342'
    session         = winrm.Session('http://'+remote_host+':5985/wsman', 
                            auth                   = (remote_username, remote_password),
                            transport              = 'ntlm',
                            server_cert_validation = 'ignore')
    result = session.run_ps(command) 
    print (result.std_out.decode("utf-8"))

nodes = [
## IP Address 		    HostName	        Role
# "10.122.36.100",	#	"SYPQLIKSENSE15"	[PRD] Proxy Engine 04"
# "10.122.36.106",	#	"SYPQLIKSENSE18"	[PRD] Proxy Engine 05"
# "10.122.36.107",	#	"SYPQLIKSENSE11"	[PRD] Proxy Engine 01"
# "10.122.36.108",	#	"SYPQLIKSENSE12"	[PRD] Proxy Engine 02"
# "10.122.36.109",	#	"SYPQLIKSENSE13"	[PRD] Proxy Engine 03"
# "10.122.36.110",	#	"SYPQLIKSENSE14"	[PRD] API 02"
# "10.122.36.119",	#	"SYPQLIKSENSE03"	[PRD] API 01"
# "10.122.36.120",	#	"SYPQLIKSENSE04"	[PRD] Central Master & Scheduler Master"
# "10.122.36.121",	#	"SYPQLIKSENSE05"	[PRD] Scheduler 05"
# "10.122.36.122",	#	"SYPQLIKSENSE06"	[PRD] Central Candidate & Scheduler 01"
# "10.122.36.123",	#	"SYPQLIKSENSE07"	[PRD] Scheduler 02"
# "10.122.36.124",	#	"SYPQLIKSENSE08"	[PRD] Scheduler 03"
# "10.122.36.220",	#	"SYPQLIKSENSE17"	[PRD] Scheduler 04"
# "10.122.36.111",	#	"PEKWPQLIK05"	    [DEV] Central Master & Scheduler Master"
# "10.122.36.112",	#	"PEKWPQLIK06"	    [DEV] Central Candidate & Scheduler 01"
# "10.122.36.114",	#	"PEKWPQLIK01"	    [DEV] Proxy Engine 01"
# "10.122.36.115",	#	"PEKWPQLIK03"	    [DEV] Proxy Engine 02"
# "10.122.36.116",	#	"PEKWPQLIK04"	    [DEV] Proxy Engine 03"
# "10.122.36.128" 	#	"SYPQLIKSENSE09"	[DEV] Scheduler 02"
# "10.122.27.37",   #   PEKWNQLIK07         [TST]
# "10.122.27.38",   #   PEKWNQLIK08         [TST]
# "10.122.27.39",   #   PEKWNQLIK09         [TST]
"10.122.27.1",    #   WIN-G7IG3TRA8E4     [TST]
# "10.122.27.3",    #   WIN-ICR6696ONF4     [TST]
# "10.122.27.4",    #   SHEWNQLIKRE         [TST]
# "10.122.27.5",    #   WIN-54U2N8LPHD0     [TST]
]

ps1  = """

# 以管理员权限运行
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}
# 服务重启告警
Write-Warning "$(Get-Date -Format '[yyyy-MM-dd HH:mm:ss]') Qlik Sense Services Rerun on: $env:COMPUTERNAME"

# 检查并停止 QS 服务运行
$services = @("Zabbix*","QlikSenseEngineService","QlikSensePrintingService", "QlikSenseProxyService","QlikSenseSchedulerService","QlikSenseServiceDispatcher","QlikSenseRepositoryService")
foreach ($service in $services)
{
    $serviceStatus = Get-Service -Name $service | Where-Object {$_.StartType -ne "Disabled"} -ErrorAction SilentlyContinue 
    if ($null -ne $serviceStatus)
    {
        if ($serviceStatus.Status -eq "Running")
        {
            # Write-Host "Stop-Service $service"
            Stop-Service -Name $service -Force
        }
        else
        {
            # Write-Host "Service $service is not running"
        }
    }
    else
    {
        # Write-Host "Service $service does not exist"
    }
}

# 等待子节点内存释放
Start-Sleep -Seconds 15
If(((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1mb) -le 256 )
    {
        $RAMthreshold = 15
    }else
    {
        $RAMthreshold = 8
    }

while($true)
{
    $memoryUsage = ((((
        Get-WmiObject -Class win32_OperatingSystem
        ).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory)/(Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize)*100)
    if($memoryUsage -lt $RAMthreshold)
    {
        # Write-Host "RAM usage < $RAMthreshold %. Continue execution"
        Break
    }
    # Write-Host "Continue execution when RAM usage < $RAMthreshold %"
    Start-Sleep -Seconds 10
}

# 启动服务
$services = @("QlikSenseRepositoryService", "QlikSenseServiceDispatcher")
    foreach ($service in $services)
    {
        # Write-Host "Start-Service $service"
        Start-Service -Name $service
    }

$maxSeconds = 180 # 设置最大检查时间为3分钟
$startTime = Get-Date # 记录开始检查的时间
$logPath = "C:\ProgramData\Qlik\Sense\Log\Repository\Trace\"
while($true)
{
    $logFiles = Get-ChildItem -Path $logPath -Filter "*.log"
    if($logFiles.Count -lt 1)
    {
        # Write-Host "live logs has been auto archived. Continue execution"
        Get-Service -Name "Qlik*" | Where-Object {$_.StartType -ne "Disabled"} | Start-Service
        Write-Host "$(Get-Date -Format '[yyyy-MM-dd HH:mm:ss]') Qlik Sense Service ReRun Completed on: $env:COMPUTERNAME" 
        Get-Service -Name "Qlik*" | Where-Object {$_.StartType -ne "Disabled"}
        Break
    }
    if((Get-Date) - $startTime -gt [TimeSpan]::FromSeconds($maxSeconds))
    {
        Write-Warning "Check log archive timeout!"
        Break
    }
    # Write-Host = "The live logs has not been auto archived, Recheck after 10 seconds."
    Start-Sleep -Seconds 10
}

"""

if __name__ == '__main__':
    for node in nodes:
        print("\033[32m {}\033[00m".format(f"{datetime.datetime.now().strftime('[%Y-%m-%d %H:%M:%S]')} The service restart command is issued to {node}" ))
        remote_server(node, ps1)
        print("\033[32m {}\033[00m".format(f"------ Rerun Command execution completed on {node} ------" ))
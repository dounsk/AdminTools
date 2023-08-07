<#
 Author: Kui.Chen
 Date: 2023-02-16 14:04:26
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-23 09:28:02
 FilePath: \Scripts\Powershell\temp\tst.ps1
 Description: PowerShell Script to check the running status of QS service, trigger stop service, and terminate the process if it exists for a long time
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Write-Warning "

████████╗██╗  ██╗███████╗     ██████╗ ███████╗    ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗
╚══██╔══╝██║  ██║██╔════╝    ██╔═══██╗██╔════╝    ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝
   ██║   ███████║█████╗      ██║   ██║███████╗    ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  
   ██║   ██╔══██║██╔══╝      ██║▄▄ ██║╚════██║    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  
   ██║   ██║  ██║███████╗    ╚██████╔╝███████║    ███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗
   ╚═╝   ╚═╝  ╚═╝╚══════╝     ╚══▀▀═╝ ╚══════╝    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝
                                                                                                      
    ██╗    ██╗██╗██╗     ██╗         ██████╗ ███████╗███████╗████████╗ █████╗ ██████╗ ████████╗       
    ██║    ██║██║██║     ██║         ██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝       
    ██║ █╗ ██║██║██║     ██║         ██████╔╝█████╗  ███████╗   ██║   ███████║██████╔╝   ██║          
    ██║███╗██║██║██║     ██║         ██╔══██╗██╔══╝  ╚════██║   ██║   ██╔══██║██╔══██╗   ██║          
    ╚███╔███╔╝██║███████╗███████╗    ██║  ██║███████╗███████║   ██║   ██║  ██║██║  ██║   ██║          
     ╚══╝╚══╝ ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝          
                                                                                                
"
Start-Sleep -Seconds 5

$services = @("Zabbix*","QlikSenseEngineService","QlikSensePrintingService", "QlikSenseProxyService","QlikSenseSchedulerService","QlikSenseServiceDispatcher","QlikSenseRepositoryService")
foreach ($service in $services)
{
    $serviceStatus = Get-Service -Name $service | Where-Object {$_.StartType -ne "Disabled"} -ErrorAction SilentlyContinue 
    if ($null -ne $serviceStatus)
    {
        if ($serviceStatus.Status -eq "Running")
        {
            Write-Host "Stop-Service $service"
            Stop-Service -Name $service
        }
        else
        {
            Write-Host "Service $service is not running"
        }
    }
    else
    {
        Write-Host "Service $service does not exist"
    }
}

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
        Write-Host "RAM usage < $RAMthreshold %. Continue execution"
        Break
    }
    Write-Host "Continue execution when RAM usage < $RAMthreshold %"
    Start-Sleep -Seconds 10
}

$services = @("QlikSenseRepositoryService", "QlikSenseServiceDispatcher")
    foreach ($service in $services)
    {
        Write-Host "Start-Service $service"
        Start-Service -Name $service
    }

while($true)
{
    $logFiles = Get-ChildItem -Path "C:\ProgramData\Qlik\Sense\Log\Repository\Trace\" -Filter "*.log"
    if($logFiles.Count -lt 1)
    {
        Write-Host "live logs has been auto archived. Continue execution"
        Break
    }
    Write-Host = "The live logs has not been auto archived, Recheck after 10 seconds."
    Start-Sleep -Seconds 10
}

Get-Service -Name "Qlik*" | Where-Object {$_.StartType -ne "Disabled"} | Start-Service

#Trigger email notification
powershell C:\ProgramData\Admintools\QsServicesEmailAlerts.ps1
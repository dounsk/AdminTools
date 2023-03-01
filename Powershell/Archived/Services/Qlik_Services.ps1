Get-Service -Name Qlik* | Format-Table -Property Status, Name, DisplayName #Check All Qlik Services
Get-CimInstance -ClassName Win32_QuickFixEngineering #Check Windows Update

Get-CimInstance -Class Win32_LogicalDisk |  Select-Object -Property Name, @{label='FreeSpace(GB)'
    expression={($_.FreeSpace/1GB).ToString('F2')}  } # Check Disk Free Space

##---Start-Service---
Throw "DO NOT RUN ALL!"

Start-Service -Name QlikSenseRepositoryDatabase
## 
Start-Service -Name QlikSenseServiceDispatcher
Start-Service -Name QlikSenseRepositoryService

Get-ChildItem -Path C:\ProgramData\Qlik\Sense\Log\Repository\Trace | Sort-Object -Property LastWriteTime, Name | Format-Table -Property LastWriteTime, Name #Check logs

Get-Service -Name Qlik* | Format-Table -Property Status, Name, DisplayName #Check Services

Start-Service -Name QlikSenseEngineService
Start-Service -Name QlikSensePrintingService
Start-Service -Name QlikSenseProxyService
Start-Service -Name QlikSenseSchedulerService

##---Stop-Service---
Throw "DO NOT RUN ALL SCRIPTS!"

Stop-Service -Name QlikSenseEngineService
Stop-Service -Name QlikSensePrintingService
Stop-Service -Name QlikSenseProxyService
Stop-Service -Name QlikSenseSchedulerService
Stop-Service -Name QlikSenseServiceDispatcher
Stop-Service -Name QlikSenseRepositoryService
##
Stop-Service -Name QlikSenseRepositoryDatabase

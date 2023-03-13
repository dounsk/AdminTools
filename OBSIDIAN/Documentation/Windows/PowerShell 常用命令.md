```md
Title : 测试防火墙端口
Author: Kui.Chen 
Date  : 2023-03-10 11:37
Description ✍:
	Source  🧲:
```
📌 Tag  : #PowerShell
🔗 Link :  

防火墙端口测试：
``` powershell

Test-NetConnection -Port 4242 -ComputerName 10.251.2.102 -InformationLevel "Detailed"
Test-NetConnection -Port 4243 -ComputerName 10.251.2.102 -InformationLevel "Detailed"
Test-NetConnection -Port 4747 -ComputerName 10.251.2.102 -InformationLevel "Detailed"
```

设置服务启动类别：
```powershell
Set-Service -Name QlikLoggingService -StartupType Manual
Set-Service -Name QlikSenseEngineService -StartupType Manual
Set-Service -Name QlikSensePrintingService -StartupType Manual
Set-Service -Name QlikSenseProxyService -StartupType Manual
Set-Service -Name QlikSenseRepositoryService -StartupType Manual
Set-Service -Name QlikSenseSchedulerService -StartupType Manual
Set-Service -Name QlikSenseServiceDispatcher -StartupType Manual
```

以管理员身份运行程序：
```powershell
powershell start-process powershell_ise.exe -verb runas
```

拷贝文件：
```powershell
Copy-Item -Path "D:\QlikSenseSharedPersistence\ArchivedLogs\sypqliksense06\Script\*" -Destination "[\\PEKWPQLIK06\ScriptLogs\PRD](file://PEKWPQLIK06/ScriptLogs/PRD)" -Recurse

Copy-Item -Path "\\sypqliksense02\Sharing_Data\QlikPlatform\Upgrade\QlikSenseNovember2021\Qlik_Sense_update(QlikSenseNovember2021Patch14).exe" -Destination "C:\Users\$env:UserName\Downloads" -Recurse
```

Powershell 中的比较运算符  
```powershell
-eq #等于  
-ne #不等于  
-gt #大于  
-ge #大于等于  
-lt #小于  
-le #小于等于  
-contains #包含  
-notcontains #不包含
```


```powershell
Write-Host "Good luck to you all the time" -fore DarkYellow 
Write-Host "Good luck to you all the time" -fore Gray 
Write-Host "Good luck to you all the time" -fore DarkGray 
Write-Host "Good luck to you all the time" -fore Blue 
Write-Host "Good luck to you all the time" -fore Green  
Write-Host "Good luck to you all the time" -fore Cyan  
Write-Host "Good luck to you all the time" -fore Red 
Write-Host "Good luck to you all the time" -fore Magenta  
Write-Host "Good luck to you all the time" -fore Yellow  
Write-Host "Good luck to you all the time" -fore White 

<#
[-ForegroundColor {Black | DarkBlue | DarkGreen | DarkCyan | DarkRed | DarkMagenta | DarkYellow | Gray | DarkGray | Blue | Green | Cyan | Red | Magenta | Yellow | White}]  

[-BackgroundColor {Black | DarkBlue | DarkGreen | DarkCyan | DarkRed | DarkMagenta | DarkYellow | Gray | DarkGray | Blue | Green | Cyan | Red | Magenta | Yellow | White}]
#>
```

![[Attached/Pasted image 20230310161501.png]]
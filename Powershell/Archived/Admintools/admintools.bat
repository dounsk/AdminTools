@echo off
mode con:cols=60 lines=30
powershell C:\ProgramData\Admintools\header.ps1

ECHO         ================ MENU ===============
ECHO         -------------------------------------
ECHO=
ECHO 	%computername%
ECHO           1: QlikSense Service Maintenance

ECHO           2: For Localhost QS Services

ECHO           3: Export Windows Events

ECHO           4: Scan System File Size

ECHO           5: Go to the Archive Logs folder

ECHO           6: Set API Monitor Status
ECHO=
ECHO         -------------------------------------

ECHO         ==========ENTER '0' TO EXIT==========
ECHO=

:loop
 
set /p a=Enter your choice: 
 
if /i '%a%'=='1' goto 1
if /i '%a%'=='2' goto 2
if /i '%a%'=='3' goto 3
if /i '%a%'=='4' goto 4
if /i '%a%'=='5' goto 5
if /i '%a%'=='6' goto 6
if /i '%a%'=='0' goto 0
echo Error, please enter again:&&goto loop


:1

powershell C:\ProgramData\Admintools\QlikSenseServiceMaintenanceTasks.ps1
@exit

:2
powershell C:\ProgramData\Admintools\LocalhostQlikSenseServiceMaintenanceTasks.ps1
@exit

:3
powershell C:\ProgramData\Admintools\exportwinevent.ps1
@exit

:4
powershell C:\ProgramData\Admintools\largefileschecking.ps1
@exit

:5
powershell Invoke-Item "\\10.122.36.118\QlikOperations\Nodes\$env:COMPUTERNAME\ArchivedLogs"
@exit

:6
powershell C:\ProgramData\Admintools\SetAPIMonitorStatus.ps1
@exit

:0
powershell C:\ProgramData\Admintools\update.ps1
@exit

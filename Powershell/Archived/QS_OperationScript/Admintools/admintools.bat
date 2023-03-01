@echo off
ECHO ================ MENU ===============

ECHO -------------------------------------

ECHO     1: RERUN Qliksense Service

ECHO     2: STOP  Qliksense Service

ECHO     3: Export Windows Events

ECHO     4: Check Large Files [Drive:C] 

ECHO     5: Check QS Service Restart Log 

ECHO -------------------------------------

ECHO ==========ENTER '0' TO EXIT==========

:loop
 
set /p a=Enter your choice: 
 
if /i '%a%'=='1' goto 1
if /i '%a%'=='2' goto 2
if /i '%a%'=='3' goto 3
if /i '%a%'=='4' goto 4
if /i '%a%'=='5' goto 5
if /i '%a%'=='0' goto 0
echo Error, please enter again:&&goto loop


:1
powershell C:\ProgramData\Admintools\rerunqliksense.ps1
@exit

:2
powershell C:\ProgramData\Admintools\stopqliksense.ps1
@exit

:3
powershell C:\ProgramData\Admintools\exportwinevent.ps1
@exit

:4
powershell C:\ProgramData\Admintools\largefileschecking.ps1
@exit

:5
powershell Invoke-Item "C:\ProgramData\Admintools\LOG"
@exit

:0
powershell C:\ProgramData\Admintools\update.ps1
@exit

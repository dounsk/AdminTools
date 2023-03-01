@echo off
ECHO ================ MENU ===============

ECHO -------------------------------------

ECHO     1: Re-run Qliksense Service

ECHO     2: Stop Qliksense Service

ECHO     3: Export the Windows events

ECHO     4: Check large files in drive:C 

ECHO -------------------------------------
ECHO ---------ENTER '9'TO UPDATE----------
ECHO ==========PRESS '0' TO QUIT==========

:loop
 
set /p a=Enter your choice: 
 
if /i '%a%'=='1' goto 1
if /i '%a%'=='2' goto 2
if /i '%a%'=='3' goto 3
if /i '%a%'=='4' goto 4
if /i '%a%'=='9' goto 9
if /i '%a%'=='0' goto Quit
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

:9
powershell C:\ProgramData\Admintools\update.ps1
@exit

:Quit
@exit
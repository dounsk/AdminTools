@echo off
ECHO ================ MENU ===============

ECHO -------------------------------------

ECHO     1: Re-run Qliksense Service

ECHO     2: Stop Qliksense Service

ECHO -------------------------------------

ECHO ==========PRESS '0' TO QUIT==========

:loop
 
set /p a=Enter your choice: 
 
if /i '%a%'=='2' goto STOP
if /i '%a%'=='1' goto Re-Run
if /i '%a%'=='0' goto Quit
echo Error, please enter again:&&goto loop

:STOP
powershell C:\Windows\System32\stopqliksense.ps1
@exit

:Re-Run
powershell C:\Windows\System32\rerunqliksense.ps1
@exit

:Quit
@exit
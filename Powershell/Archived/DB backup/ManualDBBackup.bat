@echo off
mode con:cols=100 lines=50
Set file="%~dp0%""header.ps1"
Set file=%file:"=%
powershell %file%
echo %time%: The database backup on "%computername%" is running... Do not exit!


cd "C:\Program Files\PostgreSQL\12\bin" 
pg_dump.exe -h localhost -p 4432 -U postgres -b -F t -f "\\SYPQLIKSENSE20\QlikRepositoryDatabaseBackup\QlikSense_PRD_10.122.36.117_RepositoryDB_Backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.zip" QSR

echo %time%: The database backup completed successfully.
pause
explorer \\SYPQLIKSENSE20\QlikRepositoryDatabaseBackup\
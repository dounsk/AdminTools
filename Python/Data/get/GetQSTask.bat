@echo off
echo %time%: The QlikSense Task Executing on "%computername%" is running... Do not exit!

cd / & "C:\Program Files\PostgreSQL\12\bin\psql.exe" --command "SELECT \"TaskID\", \"AppID\", \"ExecutingNodeName\", \"StartTime\" FROM \"ExecutionResults\" WHERE \"Status\" = '2' AND \"TaskID\" <> '00000000-0000-0000-0000-000000000000';" "host=localhost hostaddr=127.0.0.1 port=4432 user=postgres password=abcd-1234 dbname=QSR" > "D:\QSR\QS_Task_Execution_%date:~-4,4%%date:~-10,2%%.log"

explorer D:\QSR\
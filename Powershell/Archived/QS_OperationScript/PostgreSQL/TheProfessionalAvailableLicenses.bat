##The Professional Available Licenses
cd / & "C:\Program Files\PostgreSQL\9.6\bin\psql.exe" --command "SELECT (7493 - COUNT(DISTINCT \"ID\")) AS \"ProLicensesAvailable\" FROM \"LicenseProfessionalAccessTypes\";" "host=localhost hostaddr=127.0.0.1 port=4432 user=postgres password=abcd-1234 dbname=QSR" > "C:\qs_prd_pro_license\QS_PRD_PRO_License_%date:~-4,4%%date:~-10,2%%date:~-7,2%.csv"

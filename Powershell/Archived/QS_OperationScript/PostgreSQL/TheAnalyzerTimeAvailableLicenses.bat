##The Analyzer Time Available Licenses
cd / & "C:\Program Files\PostgreSQL\9.6\bin\psql.exe" --command "SELECT (90000 - (COUNT(DISTINCT \"ID\") * 6)) AS \"ATLicenseAvailable\" FROM \"LicenseAnalyzerTimeAccessUsageSessions\";" "host=localhost hostaddr=127.0.0.1 port=4432 user=postgres password=abcd-1234 dbname=QSR" > "C:\qs_prd_at_license\QS_PRD_AT_License_%date:~-4,4%%date:~-10,2%%date:~-7,2%.csv"
C:\qs_prd_at_license\QS_PRD_AT_License_*.csv

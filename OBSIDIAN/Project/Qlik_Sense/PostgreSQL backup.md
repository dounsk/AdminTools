### BackUp
1. Create a file `%APPDATA%\postgresql\pgpass.conf`

You may need to create a new "postgresql" directory to place the conf file.

2. In the pgpass.conf file, add the line to contain the connection information in the following format

`hostname:port:database:username:password`

For example:
```
localhost:4432:*:postgres:DBPassword123!
```

3. Then you may run the pg_dump command to verify the result. Password should not be requested then.

```sql
cd "C:\Program Files\PostgreSQL\12\bin"

pg_dump.exe -h localhost -p 4432 -U postgres -b -F t -f "\\SYPQLIKSENSE20\QlikRepositoryDatabaseBackup\QlikSense_PRD_10.122.36.117_RepositoryDB_Backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%.zip" QSR
```
Nprinting DB Backup

```sql
cd "c:\Program Files\NPrintingServer\Tools\Manager"

Qlik.Nprinting.Manager.exe backup -f [\\SYPQLIKSENSE20\QlikRepositoryDatabaseBackup\NPrinting_PRD_10.122.36.127_RepositoryDB_Backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%.zip](file://SYPQLIKSENSE20/QlikRepositoryDatabaseBackup/NPrinting_PRD_10.122.36.127_RepositoryDB_Backup_%25date:~-4,4%25%25date:~-10,2%25%25date:~-7,2%25.zip) -p "C:\Program Files\NPrintingServer\pgsql\bin" --pg-password abcd-1234
```

### Restore

Restore the repository database
```sql
cd "C:\Program Files\PostgreSQL\12\bin"
pg_restore.exe -h localhost -p 5432 -U postgres -d NPrinting "C:\Users\Downloads\RepositoryDB_Backup.zip"

    pg_restore.exe -h localhost -p 5432 -U postgres -d QSR "c:\QSR_backup.tar"  
    pg_restore.exe -h localhost -p 5432 -U postgres -d SenseServices "c:\SenseServices_backup.tar"  
    pg_restore.exe -h localhost -p 5432 -U postgres -d QSMQ "c:\QSMQ_backup.tar"  
    pg_restore.exe -h localhost -p 5432 -U postgres -d Licenses "c:\Licenses_backup.tar"
```
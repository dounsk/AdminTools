Pgadmin 清理以下日志：

	truncate "_deletedentitylog";

修改task超时时间
``` sql
UPDATE "ReloadTasks"
SET "TaskSessionTimeout" = '60'
WHERE "TaskSessionTimeout" != '60'
```

备份DB
``` cmd

cd / & mkdir QSR & "<C:\Program Files\Qlik\Sense\Repository\PostgreSQL\12\bin\pg_dump.exe>" -h localhost -p 4432 -U postgres -b -F t -f "c:\QSR\QSR_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%.tar" QSR
```

Increase the max pool size to 3000

	**QlikSenseUtil.exe**
```
C:\Program Files\Qlik\Sense\Repository\Util\qlik-sense-util\
```

Input the info as below into specific file

```
C:\ProgramData\Qlik\Sense\Engine
```

``` txt

[Settings 7]
ErrorPeakMemory=2147483648
WarningPeakMemory=1073741824
ErrorProcessTimeMs=60000
WarningProcessTimeMs=30000
DisableNewRowApplicator=0

```

数据连接信息

``` 
<connectionStrings>

    <add name="QSR" connectionString="User ID=qliksenserepository;Host='10.122.36.117';Port='4432';Database=QSR;Pooling=true;Min Pool Size=0;Max Pool Size=2000;Connection Lifetime=3600;Unicode=true;Password='abcd-1234';" providerName="Devart.Data.PostgreSql" />

    <add name="QSMQ" connectionString="User ID=qliksenserepository;Host='10.122.36.117';Port='4432';Database=QSMQ;Pooling=true;Min Pool Size=0;Max Pool Size=2000;Connection Lifetime=3600;Unicode=true;Password='abcd-1234';" providerName="Devart.Data.PostgreSql" />

    <add name="postgres" connectionString="User ID=postgres;Host=localhost;Port=4432;Database=postgres;Pooling=true;Min Pool Size=0;Max Pool Size=2000;Connection Lifetime=3600;Unicode=true;" providerName="Devart.Data.PostgreSql" />

</connectionStrings>
```

Update DB

[[Project/Qlik_Sense/HowTo/How to manually upgrade the bundled Qlik Sense PostgreSQL version to 12.5 version]]

修改服务启动状态，//需要以管理员权限执行
```powershell

    Set-Service -Name QlikLoggingService -StartupType Manual
    Set-Service -Name QlikSenseEngineService -StartupType Manual
    Set-Service -Name QlikSensePrintingService -StartupType Manual
    Set-Service -Name QlikSenseProxyService -StartupType Manual
    Set-Service -Name QlikSenseRepositoryService -StartupType Manual
    Set-Service -Name QlikSenseSchedulerService -StartupType Manual
    Set-Service -Name QlikSenseServiceDispatcher -StartupType Manual
```

Take no action a service fails:

``` cmd

sc failure QlikLoggingService reset= 0 actions= ""
sc failure QlikSenseEngineService reset= 0 actions= ""
sc failure QlikSensePrintingService reset= 0 actions= ""
sc failure QlikSenseProxyService reset= 0 actions= ""
sc failure QlikSenseRepositoryService reset= 0 actions= ""
sc failure QlikSenseSchedulerService reset= 0 actions= ""
sc failure QlikSenseServiceDispatcher reset= 0 actions= ""
```

来自 <[https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc742019(v=ws.11)](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc742019(v=ws.11))>

复制文件到指定目录
``` powershell

Copy-Item -Path "\\sypqliksense02\Sharing_Data\QlikPlatform\Upgrade\QlikSenseNovember2021\Qlik_Sense_update(QlikSenseNovember2021Patch14).exe" -Destination "C:\Users\$env:UserName\Downloads" -Recurse
```
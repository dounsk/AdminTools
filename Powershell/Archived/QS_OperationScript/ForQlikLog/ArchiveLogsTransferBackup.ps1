$Date = $(Get-Date -Format 'yyyy-MM-dd')
New-Item -path D:\QlikLogBackUp -name LogBackUp_$Date -type directory
$ServerName=$env:COMPUTERNAME
$Hostname = Get-ChildItem -Directory D:\QlikSenseSharedPersistence\ArchivedLogs -Exclude Sharedfoldersize -Name
$Backuplogs = "D:\QlikLogBackUp\LogBackUp_$(Get-Date -Format 'yyyy-MM-dd')\"
$logs = "D:\QlikLogBackUp\LogBackUp_$(Get-Date -Format 'yyyy-MM-dd')\"+$env:COMPUTERNAME+"_QlikLogBackUp_$(Get-Date -Format 'yyyy-MM-dd').txt"
$msg0 ="Date"+"	Server"+"	Archivedlog"+ "	BackupTo"
write-output $msg0 >> $logs
for($H=0; $H -lt $Hostname.Length; $H++)
{
$Hostname[$H]
$Folder = "AppMigration","Engine","Engine\Audit","Engine\System","Engine\Trace","Printing","Printing\System","Printing\Trace","Proxy","Proxy\Audit","Proxy\System","Proxy\Trace","Repository","Repository\Audit","Repository\System","Repository\Trace","Scheduler","Scheduler\Audit","Scheduler\System","Scheduler\Trace","Script"
for($F=0; $F -lt $Folder.Length; $F++)
{
$Folder[$F]
$NewFolder= $Backuplogs + $Hostname[$H]+"\" + $Folder[$F]
New-Item -Path $NewFolder -ItemType Directory
$ArchivedLogs = "D:\QlikSenseSharedPersistence\ArchivedLogs\"+$Hostname[$H] +"\"+ $Folder[$F] + "\"
$BackupTo = $Backuplogs + $Hostname[$H]+"\" + $Folder[$F] + "\"
Get-ChildItem -Path $ArchivedLogs -Filter *.log | ForEach-Object -Process{
if($_ -is [System.IO.FileInfo] -and ((Get-Date) - $_.LastWriteTime).Days -gt 120)
{
$msg=$(Get-Date -Format 'yyyy-MM-dd_HH:mm:ss')+"	"+$env:COMPUTERNAME+"	"+$_.FullName+"	"+$BackupTo ;
Write-Host  $msg -fore green
write-output $msg >> $logs
Move-Item -Path $_.FullName -Destination $BackupTo 
}
}
}
}

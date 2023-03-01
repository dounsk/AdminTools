#---PRD---
$TargetServer = "sypqliksense20"
$Hostname = Get-ChildItem -Directory ("\\"+$TargetServer + "\QlikSenseSharedPersistence\ArchivedLogs") -Name
$ExportLog = "D:\ArchiveLivelog\ArchiveLivelog_PRD_$(Get-Date -Format 'yyyy-MM-dd').csv"
$msg1 = '"Time"'+'	'+'"Live Log"'+'	' +'"Archived To"'
    write-output $msg1 >> $ExportLog

for($H=0; $H -lt $Hostname.Length; $H++)
{
    $Hostname[$H]
    $Folder = "AppMigration","Engine","Engine\Audit","Engine\System","Engine\Trace","Printing","Printing\System","Printing\Trace","Proxy","Proxy\Audit","Proxy\System","Proxy\Trace","Repository","Repository\Audit","Repository\System","Repository\Trace","Scheduler","Scheduler\Audit","Scheduler\System","Scheduler\Trace","Script"  #add the live log local folder
        for($F=0; $F -lt $Folder.Length; $F++)
            {
            $Folder[$F]
            $Livelogs = "\\"+$Hostname[$H]+"\Log\" + $Folder[$F] + "\"
            $ArchivedLogs = "\\"+$TargetServer + "\QlikSenseSharedPersistence\ArchivedLogs\"+$Hostname[$H]+"\" + $Folder[$F] + "\"
            Get-ChildItem -Path $Livelogs -Filter *T*.log | ForEach-Object -Process{
#if($_ -is [System.IO.FileInfo] -and ((Get-Date) - $_.CreationTime).Days -gt 1) #Filter logs creation time
#{
            $msg ='"'+ $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+'"'+'	'+'"'+($_.FullName)+'"'+'	'+'"'+ $ArchivedLogs+'"'
            write-output $msg >> $ExportLog
            Move-Item -Path $_.FullName -Destination $ArchivedLogs -Force
#}
 }
}
}
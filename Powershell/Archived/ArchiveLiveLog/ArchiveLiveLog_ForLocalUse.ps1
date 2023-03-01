$TargetServer = "\\PEKWPQLIK05" #Modify the target server PRD:'\\sypqliksense20' or DEV:'\\PEKWPQLIK05'
$Hostname = $env:COMPUTERNAME #Get local hostname
$Folder = "AppMigration","Engine","Engine\Audit","Engine\System","Engine\Trace","Printing","Printing\System","Printing\Trace","Proxy","Proxy\Audit","Proxy\System","Proxy\Trace","Repository","Repository\Audit","Repository\System","Repository\Trace","Scheduler","Scheduler\Audit","Scheduler\System","Scheduler\Trace","Script"  #add the live log local folder
for($i=0; $i -lt $Folder.Length; $i++)
{
 $Folder[$i]
 $StartFolder = "C:\ProgramData\Qlik\Sense\Log\" + $Folder[$i] + "\"
 $TargetFolder = $TargetServer + "\QlikSenseSharedPersistence\ArchivedLogs\$(Hostname)\" + $Folder[$i] + "\"
 Get-ChildItem -Path $StartFolder -Filter *.log | ForEach-Object -Process{
  if($_ -is [System.IO.FileInfo] -and ((Get-Date) - $_.CreationTime).Days -gt 1) #Files Last Write Time > 1 day
   {
    Move-Item -Path $_.FullName -Destination $TargetFolder 
   }
 }
}
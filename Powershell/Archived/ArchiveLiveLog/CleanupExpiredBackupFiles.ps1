$Folder = "D:\QlikRepositoryDatabaseBackup"
$Log = $Folder+"\DatabaseBackup_CleanupLogs_$(Get-Date -Format "yyyy").txt"

if((Test-Path $Log) -ne  "Ture")
{	
    $msg = "#Following the backup policy, the DB backup files are only kept for the 7 days, and the expired ones will be removed."
    $title = "Date"+"	"+"Server"+"	"+"SourceFile"+"	"+"State" 
    write-output $msg > $Log
    write-output $title >> $Log
}

Get-ChildItem -Path $Folder -Filter *.zip | ForEach-Object -Process{
  if($_ -is [System.IO.FileInfo] -and ((Get-Date) - $_.CreationTime).Days -gt 7) #Files Created date > 7 day
   {
    if((Test-Path $_.FullName) -eq "True")
    {	
    $msg=$(Get-Date -Format '<yyyy-MM-dd HH:mm:ss>')+"	"+$env:COMPUTERNAME+"	"+$_.FullName+"	"+"Backup file expired, cleaned up." ;
    Write-Host  $msg -fore yellow;
    write-output $msg >> $Log
    Remove-Item -Path $_.FullName 
    }
   }
 }
exit
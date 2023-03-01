$F_APPs = "D:\QlikSenseSharedPersistence\Apps"
$F_Logs = "D:\QlikSenseSharedPersistence\ArchivedLogs"
$F_Sharing_Data = "D:\Sharing_Data"
$Export = "C:\Users\"+$env:UserName+"\Downloads\"+$env:COMPUTERNAME+"_FolderSize"+$Directory+"_$(Get-Date -Format 'yyyy-MM-dd.HHMM').txt"

$Date=Get-Date -Format 'yyyy/MM/dd'
$Time=Get-Date -Format 'HH:MM:ss'
$APPsSize = (Get-ChildItem $F_APPs -recurse | Measure-Object -property length -sum)
$APPs="{0:N2}" -f ($APPsSize.sum / 1GB)
$LogsSize = (Get-ChildItem $F_Logs -recurse | Measure-Object -property length -sum)
$Logs="{0:N2}" -f ($APPsSize.sum / 1GB)
$Sharing_DataSize = (Get-ChildItem $F_Sharing_Data -recurse | Measure-Object -property length -sum)
$Sharing_Data="{0:N2}" -f ($Sharing_DataSize.sum / 1GB)
$msg1 ="FolderName , FullPath , Date , Time ,  Size(GB)"
write-output $msg1 >> $Export
$msg2 ='Apps' +' , ' + $F_APPs + ' , '+ $Date +' , '+ $Time+ ' , '+ $APPs 
write-output $msg2 >> $Export
$msg3 = 'Logs' +' , ' + $F_Logs + ' , '+ $Date +' , '+ $Time+ ' , '+ $Logs >> $Export
write-output $msg3 >> $Export
$msg4 = 'Sharing_Data' +' , ' + $F_Sharing_Data + ' , '+ $Date +' , '+ $Time+ ' , '+ $Sharing_Data >> $Export
write-output $msg4 >> $Export
Invoke-Item $Export #If it is automatically triggered, you need to comment this.
exit
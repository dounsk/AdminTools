$startFolder = "D:\QlikSenseSharedPersistence\ArchivedLogs"
$Date=Get-Date -Format 'yyyy/MM/dd'
$Time=Get-Date -Format 'HH:mm'
$subFolderItems = (Get-ChildItem $startFolder -recurse | Measure-Object -property length -sum)
 $FileSize="{0:N2}" -f ($subFolderItems.sum / 1GB)
 $Unit='GB'

write-host 'Logs' ' \ ' $Date ' \ ' $Time ' \ ' $FileSize ' \ ' $Unit

exit
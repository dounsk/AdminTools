$ExApps="\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\Details\Apps\DEV_Appslist_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$Apps =  Powershell "& 'C:\ProgramData\Foldersize\AQdetails\Apps.ps1'" 
write-output "Scan date, Name, Size(B), CreationTime , LastAccessTime, LastWriteTime" >> $ExApps
write-output $Apps >> $ExApps
#-------------------------------
#$ExQvds="\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\Details\Sharing_Data\DEV_Sharing_Datalist_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
#$Qvds =  Powershell "& 'C:\ProgramData\Foldersize\AQdetails\Sharing_Data.ps1'" 
#write-output "Scan date, Name, Size(GB), Unit" >> $ExQvds
#write-output $Qvds >> $ExQvds
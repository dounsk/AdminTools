$Path_APPs = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\sypqliksense02_Apps.txt"
$Path_Logs = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\sypqliksense02_Logs.txt"
$Path_Sharing_Data = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\sypqliksense02_Sharing_Data.txt"

$Path_kpi_APPs = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\KPI\KPI_sypqliksense02_Apps.txt"
$Path_kpi_Logs = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\KPI\KPI_sypqliksense02_Logs.txt"
$Path_kpi_Sharing_Data = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\KPI\KPI_sypqliksense02_Sharing_Data.txt"

$APPs = Powershell "& 'C:\ProgramData\Foldersize\APPs.ps1'"
$Logs = Powershell "& 'C:\ProgramData\Foldersize\Logs.ps1'"
$Sharing_Data = Powershell "& 'C:\ProgramData\Foldersize\Sharing_Data.ps1'"


write-output $APPs >> $Path_APPs
write-output $Logs >> $Path_Logs
write-output $Sharing_Data >> $Path_Sharing_Data 

Clear-Content $Path_kpi_APPs 
Clear-Content $Path_kpi_Logs 
Clear-Content $Path_kpi_Sharing_Data 

write-output $APPs >> $Path_kpi_APPs 
write-output $Logs >> $Path_kpi_Logs 
write-output $Sharing_Data >> $Path_kpi_Sharing_Data 
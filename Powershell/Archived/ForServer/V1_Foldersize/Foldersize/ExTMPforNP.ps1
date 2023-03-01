$Exfile="\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\sypqliksense02_TmpFile_list_NP.txt"
$ps =  Powershell "& 'C:\ProgramData\Foldersize\tmp.ps1'" 
Clear-Content $Exfile
write-output $ps >> $Exfile
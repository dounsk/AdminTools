$Path = "\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\sypqliksense02_TmpFile_list.txt"
$ps =  Powershell "& 'C:\ProgramData\Foldersize\tmp.ps1'"

write-output $ps  >> $Path
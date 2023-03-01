#Start-Process powershell -Verb runAs{
$Exfile="\\pekwpqlik05\QlikSenseSharedPersistence\ArchivedLogs\Sharedfoldersize\SmbOpenFile\SmbOpenFile_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$ps = powershell "& 'D:\TST\SmbOpenFile.ps1'" 
write-output "FileId , Path , ShareRelativePath , ClientComputerName , ClientUserName , ScanTime" >> $Exfile
write-output $ps >> $Exfile

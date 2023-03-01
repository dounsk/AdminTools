$Exfile="D:\Qliks\Powershell\APP qvd tmp\Apps\Appslist_$(Get-Date -Format 'yyyyMMdd_HHmm').csv"
$ps =  Powershell "& 'D:\Qliks\Powershell\APP qvd tmp\Apps\Apps.ps1'" 
write-output "Name, FullName, Size(B), CreationTime , LastAccessTime, LastWriteTime" >> $Exfile
write-output $ps >> $Exfile
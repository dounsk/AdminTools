$startFolder = "D:\QlikSenseSharedPersistence\Apps"
$Export = "C:\Users\"+$env:UserName+"\Downloads\"+$env:COMPUTERNAME+"_AppsList-"+$Directory+"_$(Get-Date -Format 'yyyy-MM-dd.HHMM').txt"
$msg1 ="Name , FullName , Size(MB) ,  CreationTime , LastAccessTime ,  LastWriteTime"
write-output $msg1 >> $Export
Get-ChildItem -Path $startFolder  -Exclude *.lock  -Force | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
$msg =($_.name+' , '+$_.FullName+' , '+($_.Length / 1mb)+' , '+$_.CreationTime+' , '+$_.LastWriteTime)
write-output $msg >> $Export
Write-Host $_.name' '$_.FullName'   '$_.Length '    '$_.CreationTime'   '$_.LastAccessTime' '$_.LastWriteTime -fore green ;
}
Invoke-Item $Export #If it is automatically triggered, you need to comment this.
exit
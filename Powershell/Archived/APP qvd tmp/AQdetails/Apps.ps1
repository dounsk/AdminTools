$startFolder = "D:\QlikSenseSharedPersistence\Apps"
$Date=Get-date -Format 'MM/dd/yyyy'
Get-ChildItem -Path $startFolder  -Exclude *.lock  -Force | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{

Write-Host $Date ' , '$_.name' , '$_.Length ' , '$_.CreationTime' , '$_.LastAccessTime' , '$_.LastWriteTime -fore green ;
}



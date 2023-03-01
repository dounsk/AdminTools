$startFolder = "D:\QlikSenseSharedPersistence\Apps"

Get-ChildItem -Path $startFolder  -Exclude *.lock  -Force | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{

Write-Host($_.name, $_.FullName,$_.Extension, $_.CreationTime, $_.LastAccessTime, $_.LastWriteTime, $_.Attributes) -fore green ;
}



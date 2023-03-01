$startFolder = "D:\QlikSenseSharedPersistence\Apps"
$Date=Get-Date -Format 'yyyy/MM/dd'
Get-ChildItem -Path $startFolder -Filter *.tmp | ForEach-Object -Process{
if($_ -is [System.IO.FileInfo] -and ($_.CreationTime -ge [System.DateTime]::Today))
{
Write-Host $Date' , ' $_.name' , '$_.FullName' , '$_.Extension' , '$_.CreationTime' , '$_.Attributes' , 1';
}
}


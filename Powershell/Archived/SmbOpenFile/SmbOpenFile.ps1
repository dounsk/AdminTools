Get-SmbOpenFile | ForEach-Object -Process{

Write-Host $_.FileId' , ' $_.Path' , '$_.ShareRelativePath' , '$_.ClientComputerName' , '$_.ClientUserName' , '(Get-Date -Format 'yyyy_MM_dd HH:mm:ss') ;
}
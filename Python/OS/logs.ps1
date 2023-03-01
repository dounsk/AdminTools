$Folder = "\\10.122.36.118\Sharing_Data\Share_Folder\"

Get-ChildItem -Path $Folder -Filter *.log -Recurse | ForEach-Object -Process{
   if($_ -is [System.IO.FileInfo] -and ((Get-Date) - $_.LastWriteTime).Days -gt 170)
   {	
    $msg=$(Get-Date -Format '<yyyy-MM-dd HH:mm:ss>')+"	"+$env:COMPUTERNAME+"	"+$_.LastWriteTime+"	"+$_.FullName ;
    Write-Host  $msg -fore yellow;
    $msg > $Env:TEMP\tmp.txt
    python $Env:TEMP"\tmp.py"
   }
 }

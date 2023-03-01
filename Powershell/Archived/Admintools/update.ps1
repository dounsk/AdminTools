$source = "\\pekwpqlik06\Sharing_Data\CSV_kui\ps1\Admintools\"
$local = "C:\ProgramData\Admintools\"
$Desktop = "C:\Users\"+$env:UserName+"\Desktop\"
Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    $msg ='> '+$_.LastWriteTime+ '	Updated	> '+ $_.name
    Write-Host $msg -fore green
    Copy-Item -Path $_.FullName -Destination $local -Force
}
Copy-Item -Path "C:\ProgramData\Admintools\AdminTools.lnk" -Destination $Desktop -Force

exit
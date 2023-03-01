$source = "\\pekwpqlik06\Sharing_Data\CSV_kui\ps1\Admintools\"
$local = "C:\ProgramData\Admintools\"
Write-Host " "
Write-Host ----------------------------
Write-Host UPDATE -> EXIT
Write-Host ----------------------------
Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    $msg ='Newest '+$_.LastWriteTime+ '	Updated	> '+ $_.name
    Write-Host $msg -fore green
    Copy-Item -Path $_.FullName -Destination $local -Force
}
$seconds = 3
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity EXITING -Status "$($seconds - $_)s ..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
exit
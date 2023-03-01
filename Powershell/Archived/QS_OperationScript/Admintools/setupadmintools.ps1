New-Item -path C:\ProgramData -name Admintools -type directory
New-Item -path C:\ProgramData\Admintools -name LOG -type directory
$source = "\\pekwpqlik06\Sharing_Data\CSV_kui\ps1\Admintools\"
$local = "C:\ProgramData\Admintools\"
$Desktop = "C:\Users\"+$env:UserName+"\Desktop\"
Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    
    #Write-Host "Source file"$_.name' the last updated in'$_.LastWriteTime -fore green ;
    Write-Host 'Setup' $_.Name -fore green
    Copy-Item -Path $_.FullName -Destination $local -Force
}
Copy-Item -Path "C:\ProgramData\Admintools\AdminTools.lnk" -Destination $Desktop -Force

Write-Host 'Succeeded' -fore green
$seconds = 5
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity Exit -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
exit
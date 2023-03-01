$source = "\\pekwpqlik06\Sharing_Data\CSV_kui\ps1\Admintools\"
$local = "C:\ProgramData\Admintools\"
Write-Host " "
Write-Host "Check the source and local file update time difference:"
Write-Host " "
Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    
    #Write-Host "Source file"$_.name' the last updated in'$_.LastWriteTime -fore green ;
    $name = $_.name
    $msg =('Source-	' + $_.name+'	>	Updated:	'+$_.LastWriteTime)
    Write-Host $msg -fore green
    Get-ChildItem -Path $local$name  -Filter *.ps1 | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    $msg2 =('Local-	' + $_.name+'	>	Updated:	'+$_.LastWriteTime)
    Write-Host $msg2 -fore yellow
    Write-Host "---"
    }
    }
Write-Host " "
Write-Host "Updating......"  
Write-Host " "

Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    
    #Write-Host "Source file"$_.name' the last updated in'$_.LastWriteTime -fore green ;
    $name2 = $_.name
    Write-Host 'Updated' $_.Name
    Copy-Item -Path $_.FullName -Destination $local -Force
}

Write-Host " "
Write-Host "Double check"  
Write-Host " "

Get-ChildItem -Path $source | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    
    #Write-Host "Source file"$_.name' the last updated in'$_.LastWriteTime -fore green ;
    $name3 = $_.name
    $msg =('Source-	' + $_.name+'	>	Updated:	'+$_.LastWriteTime)
    Write-Host $msg -fore green
    Get-ChildItem -Path $local$name3  -Filter *.ps1 | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    $msg2 =('Local-	' + $_.name+'	>	Updated:	'+$_.LastWriteTime)
    Write-Host $msg2 -fore yellow
    }
    }
$seconds = 5
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity Exit -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
exit
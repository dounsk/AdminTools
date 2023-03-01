$Directory = "C"
$TargetDirectory = $Directory+":\"
$FolderName = Get-ChildItem -Directory $TargetDirectory -Name
$ExportLog = "C:\Users\"+$env:UserName+"\Downloads\"+$env:COMPUTERNAME+"_FilesSizeCheckList_Drive-"+$Directory+"_$(Get-Date -Format 'yyyy-MM-dd.hhmm').csv"
$Exported="C:\Users\"+$env:UserName+"\Downloads\"
Write-Host "--------------------------------------------------------------------"
Write-Host " It is best to run as an administrator"
Write-Host " Will check the files larger than 100MB in the drive:" $Directory 
Write-Host " The list will be exported to " $Exported 
Write-Host " please wait a moment."
Write-Host "--------------------------------------------------------------------"

$msg1 ="FullName , Size(MB) , Created , LastModified"
write-output $msg1 >> $ExportLog

for($H=0; $H -lt $FolderName.Length; $H++)
{
    $FolderName[$H]
    $path = $TargetDirectory+($FolderName[$H])+"\"
    Get-ChildItem -Path $path -Recurse | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    if ($_.Length -gt 100MB) #Check and export files larger than 100MB in size
    {
    #Write-Host $_.FullName','($_.Length / 1mb)','$_.CreationTime','$_.LastWriteTime -fore green ;

    $msg =($_.FullName+','+($_.Length / 1mb)+','+$_.CreationTime+','+$_.LastWriteTime)
    write-output $msg >> $ExportLog
    }
 }
}

Invoke-Item $Exported
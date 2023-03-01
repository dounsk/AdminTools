If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$Directory = "C"
$TargetDirectory = $Directory+":\"
$FolderName = Get-ChildItem -Directory $TargetDirectory -Name
$ExportLog = "C:\Users\"+$env:UserName+"\Downloads\"+$env:COMPUTERNAME+"_LargeFiles_drive-"+$Directory+"_$(Get-Date -Format 'yyyy-MM-dd.hhmm').txt"
$Exported="C:\Users\"+$env:UserName+"\Downloads\"
Write-Host "--------------------------------------------------------------------" -fore green
Write-Host " Checking for files size > 100MB in the system directory:" $Directory  -fore green
Write-Host " Export to: " $Exported  -fore green
Write-Host " The file will be open after exported, Please waiting……" -fore green
Write-Host "--------------------------------------------------------------------" -fore green
$msg1 ="FullName   Size   Created   LastModified"
write-output $msg1 >> $ExportLog
for($H=0; $H -lt $FolderName.Length; $H++)
{
    $FolderName[$H]
    $path = $TargetDirectory+($FolderName[$H])+"\"
    Get-ChildItem -Path $path -Recurse | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    if ($_.Length -gt 100MB) #Check and export files larger than 100MB in size
    {
    Write-Host $_.FullName','($_.Length / 1mb)','$_.CreationTime','$_.LastWriteTime -fore green ;

    $msg =($_.FullName+' , '+($_.Length / 1mb)+' MB , Created '+$_.CreationTime+' , LastModified '+$_.LastWriteTime)
    write-output $msg >> $ExportLog
    }
 }
}
Invoke-Item $Exported
Start-Sleep -Seconds 1
Invoke-Item $ExportLog
$parameters = @{
#-------------------------------
# Target Server: 
  ComputerName = "pekwnqlik08"
#-------------------------------
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {

#Set up an FTP target server, the home directory should be set in the target server's FileZilla.
$FTPServer = "10.122.36.118:22"

#Set size threshold for file checking
$sizeToCheck = "100MB"

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$Directory = "C"
$TargetDirectory = $Directory+":\"
$FolderName = Get-ChildItem -Directory $TargetDirectory -Name
$ExportLog = "C:\Windows\Temp\"+$env:COMPUTERNAME+"_SystemFileSizeCheck_$(Get-Date -Format 'yyyy-MM-dd.hhmm').csv"
Write-Warning "Do not quit or the large size files list will not be archived."
Write-Host " Checking for files size > $sizeToCheck in $env:COMPUTERNAME system directory:" $Directory  -fore green
Start-Sleep -Seconds 1
$msg1 ='"'+"ServerName"+ '"'+'	' +'"'+"FullPath"+ '"'+'	' +'"'+ "Size(MB)" + '"'+'	' +'"'+  "Created" + '"'+'	' +'"'+ "LastModified" +'"'+'	' +'"'+ "Tag" +'"'
write-output $msg1 >> $ExportLog
for($H=0; $H -lt $FolderName.Length; $H++)
{
    $FolderName[$H]
    $path = $TargetDirectory+($FolderName[$H])+"\"
    Get-ChildItem -Path $path -Recurse | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    if ($_.Length -gt $sizeToCheck)
    {
    $msg ='"'+ $env:COMPUTERNAME + '"'+'	' +'"'+$_.FullName+ '"'+'	' +'"'+ ($_.Length / 1mb) + '"'+'	' +'"'+  $_.CreationTime + '"'+'	' +'"'+ $_.LastWriteTime +'"'+'	' +'"'+ "Size>$sizeToCheck" +'"'
    Write-Host $env:COMPUTERNAME "," $_.FullName "," ($_.Length / 1mb) "MB" -fore green;
    write-output $msg >> $ExportLog
    }
 }
}
$Directory = "D"
$TargetDirectory = $Directory+":\"
$FolderName = Get-ChildItem -Directory $TargetDirectory -Name
Write-Host " Checking for files size > $sizeToCheck in $env:COMPUTERNAME system directory:" $Directory  -fore green
Start-Sleep -Seconds 1
for($H=0; $H -lt $FolderName.Length; $H++)
{
    $FolderName[$H]
    $path = $TargetDirectory+($FolderName[$H])+"\"
    Get-ChildItem -Path $path -Recurse | Where-Object {$_.PSIsContainer -eq $false}| ForEach-Object -Process{
    if ($_.Length -gt $sizeToCheck)
    {
    $msg ='"'+ $env:COMPUTERNAME + '"'+'	' +'"'+$_.FullName+ '"'+'	' +'"'+ ($_.Length / 1mb) + '"'+'	' +'"'+  $_.CreationTime + '"'+'	' +'"'+ $_.LastWriteTime +'"'+'	' +'"'+ "Size>$sizeToCheck" +'"'
    Write-Host $env:COMPUTERNAME "," $_.FullName "," ($_.Length / 1mb) "MB" -fore green;
    write-output $msg >> $ExportLog
    }
 }
}
Start-Sleep -Seconds 1
#-----Archive log------
$Dir="C:\Windows\Temp\"
$username='Qlikplatform'
$password='Qlikplatform'
$WebClient = New-Object System.Net.WebClient
$FTP = "ftp://${username}:$password@$FTPServer/Nodes/$env:COMPUTERNAME/ArchivedLogs/"
foreach($item in (Get-ChildItem $Dir "$env:COMPUTERNAME*.csv")){
Write-Host "Uploading:	$item TO $FTPServer/Nodes/$env:COMPUTERNAME/ArchivedLogs/ ..."-fore green
$URI = New-Object System.Uri($FTP+$item.Name)
$WebClient.UploadFile($URI, $item.FullName)
}
remove-item "C:\Windows\Temp\$env:COMPUTERNAME*.csv" 
1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
exit
}
}
Invoke-Command @parameters
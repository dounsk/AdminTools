#---- Ftp Archive Logs ----
$Dir="C:\Users\tableau\Desktop\" #Local directory
$Hostname= $env:COMPUTERNAME
$username='Qlikplatform'
$password='Qlikplatform'
$WebClient = New-Object System.Net.WebClient
$FTP = "ftp://${username}:$password@10.122.36.112/$Hostname/" #FTP directory

foreach($item in (Get-ChildItem $Dir "*.log")){
Write-Host "Uploading:	$item ..."-fore green
$URI = New-Object System.Uri($FTP+$item.Name)
$WebClient.UploadFile($URI, $item.FullName)
}
Start-Sleep -Seconds 2
exit
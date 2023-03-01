$parameters = @{
#-------------------------------
# Target Server: 
  ComputerName = "pekwnqlik08"
#-------------------------------
  ConfigurationName = 'microsoft.powershell'
  ScriptBlock = {

    #Set up an FTP target server, the home directory should be set in the target server's FileZilla.
    $FTPServer = "10.122.36.118:22"
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
    }
    $Directory = "C:\Windows\Temp\"+$env:COMPUTERNAME+"_WindowsEvent_$(Get-Date -Format 'yyyyMMdd').evtx"
    Write-Host "--------------------------------------------------------------------" -fore green
    Write-Host " Export the Windows Application log of the last 7 days to:" -fore green
    Write-Host " \\sypqliksense02\QlikOperations\Nodes\PEKWNQLIK08\ArchivedLogs" -fore green
    Write-Host "--------------------------------------------------------------------" -fore green
    wevtutil epl Application $Directory /q:"*[System[(Level=1  or Level=2 or Level=3 or Level=4 or Level=0 or Level=5) and TimeCreated[timediff(@SystemTime) <= 604800000]]]"
    Start-Sleep -Seconds 1
    #-----Archive log------
    $Dir="C:\Windows\Temp\"
    $username='Qlikplatform'
    $password='Qlikplatform'
    $WebClient = New-Object System.Net.WebClient
    $FTP = "ftp://${username}:$password@$FTPServer/Nodes/$env:COMPUTERNAME/ArchivedLogs/"
    foreach($item in (Get-ChildItem $Dir "$env:COMPUTERNAME*.evtx")){
    Write-Host "Uploading:	$item TO $FTPServer/Nodes/$env:COMPUTERNAME/ArchivedLogs/ ..."-fore green
    $URI = New-Object System.Uri($FTP+$item.Name)
    $WebClient.UploadFile($URI, $item.FullName)
    }
    remove-item "C:\Windows\Temp\$env:COMPUTERNAME*.evtx" 
    1..3 |ForEach-Object { $percent = $_ * 100 / 3;Write-Progress -Activity Exit -Status "$(3 - $_) seconds exit..." -PercentComplete $percent;Start-Sleep -Seconds 1}
    exit
}
}
Invoke-Command @parameters
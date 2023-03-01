If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$Directory = "C:\Users\"+$env:UserName+"\Downloads\"+$env:COMPUTERNAME+"_WindowsEvent_$(Get-Date -Format 'yyyyMMdd').evtx"
$Exported="C:\Users\"+$env:UserName+"\Downloads\"
Write-Host "--------------------------------------------------------------------" -fore green
Write-Host " Export the Windows Application log of the last 7 days  -fore green" -fore green
Write-Host " Export to: " $Exported  -fore green
Write-Host " Please waiting……" -fore green
Write-Host "--------------------------------------------------------------------" -fore green
wevtutil epl Application $Directory /q:"*[System[(Level=1  or Level=2 or Level=3 or Level=4 or Level=0 or Level=5) and TimeCreated[timediff(@SystemTime) <= 604800000]]]"
Invoke-Item $Exported
$ExportLog = "C:\Users\tableau\Downloads\"+$env:COMPUTERNAME+"_RAMChecking_$(Get-Date -Format 'yyyy-MM-dd.hhmm').csv"
$msg0 ='"'+"Time"+ '"'+'	' +'"'+"Hostname"+ '"'+'	' +'"'+ "Total RAM(GB)" + '"'+'	' +'"'+  "RAM Usage(GB)" 
$TotalRAM = ((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1Mb).ToString('###.##', $CultInfo)
Write-Host $msg0 -fore green
write-output $msg0 >> $ExportLog
for($i=0; $i -lt 300; $i++)
{
$Time = $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 
$Hostname = $env:COMPUTERNAME 
$RAM_Usage =  (((Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize-(Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory))/1mB.ToString('###.##', $CultInfo) 
$msg1 ='"'+$Time+ '"'+'	' +'"'+$Hostname+ '"'+'	' +'"'+ $TotalRAM + '"'+'	' +'"'+ $RAM_Usage + '"'
Write-Host $msg1 -fore green
Write-Host "--------------------------------------------------------------------" -fore green
write-output $msg1 >> $ExportLog
Start-Sleep -Seconds 1
}
Invoke-Item -Path "C:\Users\tableau\Downloads\"
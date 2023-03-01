#Need to manually modify the matching hostname ($MatchName)
$ServiceHealthCheck = '"'+ (Get-Content "\\SYPQLIKSENSE14\ServiceHealthCheck\API\API_ALERT.txt")+'"'
$ExportLog = "\\SYPQLIKSENSE14\ServiceHealthCheck\ServiceHealthCheck.log"
$hostname = $env:COMPUTERNAME
$MatchName = "(.+PEKWNQLIK08)(.+)"
$msg1 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $hostname match:$MatchName PASSED: "+$ServiceHealthCheck
$msg2 = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $hostname match:$MatchName WARNING: "+$ServiceHealthCheck+" Triggered Re-Run Task"

if ($ServiceHealthCheck -match $MatchName)
{
    Write-Host $msg2 -fore red
    write-output $msg2 >> $ExportLog
    powershell C:\ProgramData\Qlik\Sense\ServiceHealthCheck\RERUNQLIKSERVICE.ps1 -verb runas

}else{

    Write-Host $msg1 -fore green
    write-output $msg1 >> $ExportLog
}
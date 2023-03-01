# wait 5 seconds for spooler service to stop
$serviceToMonitor = Get-Service -Name Spooler
$desiredStatus = [System.ServiceProcess.ServiceControllerStatus]::Stopped
$maxTimeout = New-TimeSpan -Seconds 5

try
{
  $serviceToMonitor.WaitForStatus($desiredStatus, $maxTimeout)
}
catch [System.ServiceProcess.TimeoutException]
{
  Write-Warning 'Service did not reach desired status within timeframe.'
}
Enum ShowStates
{
  Hide = 0
  Normal = 1
  Minimized = 2
  Maximized = 3
  ShowNoActivateRecentPosition = 4
  Show = 5
  MinimizeActivateNext = 6
  MinimizeNoActivate = 7
  ShowNoActivate = 8
  Restore = 9
  ShowDefault = 10
  ForceMinimize = 11
}
$code = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$type = Add-Type -MemberDefinition $code -Name myAPI -PassThru
$process = Get-Process -Id $PID
$hwnd = $process.MainWindowHandle
$type::ShowWindowAsync($hwnd, [ShowStates]::Hide)
#------------------------------------------------------------
# make sure this points to the log file.
$Target = "\\sypqliksense02\QlikOperations\WARNING\Qlik_SERVICE_WARNING.txt"
#------------------------------------------------------------
$LastModified = $(Get-Item $Target).lastwritetime
$Thresholds = $(Get-Item $Target).lastwritetime
$i = 0;while($i -le  1440){$i ++
if($LastModified -gt  $Thresholds){      
    python C:\Windows\QsSend_email.py
    $Thresholds = $(Get-Item $Target).lastwritetime
    $LastModified = $(Get-Item $Target).lastwritetime 
    }
  $LastModified = $(Get-Item $Target).lastwritetime 
        Start-Sleep -second 60
}
Get-ScheduledTask -TaskName 'WARNING' | Start-ScheduledTask
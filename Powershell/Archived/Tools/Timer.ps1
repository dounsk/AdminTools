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
Add-Type -AssemblyName  System.Windows.Forms
$message = " ⏰ It's "+$(Get-Date -Format "HH:mm:ss")+", Ready to Go? "
$title = (Get-Date).ToString('🖐 [dddd]  MMMM/dd', [System.Globalization.CultureInfo]'en-us')
$Buttons = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Question)

#可用的按钮样式 MessageBoxButtons: OK / OKCancel / AbortRetryIgnore / YesNoCancel / YesNo / RetryCancel
#可用的图标样式 MessageBoxIcon: None / Hand / Error / Stop / Question / Exclamation / Warning / Asterisk / Information
if($Buttons -eq "ok")
{
    $m = "$(Get-Date -Format "mm")"
     while($m -le 57)
    {
        $m = "$(Get-Date -Format "mm")"
        Start-Sleep -second 15
    }
    $message = " Time is Up, Let's Go!"
    $title = (Get-Date).ToString('⏳ -- HH:MM --', [System.Globalization.CultureInfo]'en-us')
    $Buttons = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Exclamation)
   
}
exit
Add-Type -AssemblyName  System.Windows.Forms
$message = $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
$title = 'Timer'
[System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Exclamation)

#可用的按钮样式 MessageBoxButtons: OK / OKCancel / AbortRetryIgnore / YesNoCancel / YesNo / RetryCancel
#可用的图标样式 MessageBoxIcon: None / Hand / Error / Stop / Question / Exclamation / Warning / Asterisk / Information
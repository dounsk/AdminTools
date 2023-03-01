# Used for daily triggering
$Hour = "$(Get-Date -Format "HH")"
$message = (Get-Date).ToString(' -- yyyy/MM/dd HH:MM --', [System.Globalization.CultureInfo]'en-us')

if ($Hour -eq 20)
   {
    Powershell C:\ProgramData\trigger\backuppy.ps1
   }

if ($Hour -eq 21)
   {
    Powershell C:\ProgramData\trigger\UbuntuBackup.ps1
   }

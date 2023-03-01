Add-Type -AssemblyName  System.Windows.Forms
$message = $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" / Continue?"
$title = 'Time reminder'
$Buttons = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Exclamation)

#可用的按钮样式 MessageBoxButtons: OK / OKCancel / AbortRetryIgnore / YesNoCancel / YesNo / RetryCancel
#可用的图标样式 MessageBoxIcon: None / Hand / Error / Stop / Question / Exclamation / Warning / Asterisk / Information

if($Buttons -eq "ok")
{
    $c = "$(Get-Date -Format "mm")"
    while($c -le 57)
    {
        $c = "$(Get-Date -Format "mm")"
        Write-Host "-------------------"
        Write-Host "   - - Timer - -   "
        Write-Host $(Get-Date -Format "    yyyy-MM-dd") -fore green 
        Write-Host $(Get-Date -Format "     HH:mm:ss") -fore green
        Write-Host "-------------------"
        #Start-Sleep -minute 1
        Start-Sleep -second 1
        cls
    }
    $m = "$(Get-Date -Format "mm")"
        Write-Host "  Last 2 Minutes"
        Write-Host "------------------"
        Write-Host "   HH:MM   ss"
    while($c -le 58)
    {
        $c = "$(Get-Date -Format "mm")"
        Write-Host $(Get-Date -Format "     HH:mm:ss") -fore Yellow
        Write-Host "    +  +  +  +" -fore DarkGray
        #Start-Sleep -minute 1
        Start-Sleep -second 1
    }
    cls
    $seconds = 59
    1..$seconds |
    ForEach-Object { $percent = $_ * 100 / $seconds;
    Write-Progress -Activity "1 minute" -Status "$($seconds - $_) seconds left..." -PercentComplete $percent;
    Start-Sleep -Seconds 1
    }
    for ($i = 1; $i -le 20; $i++ )
    {
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore DarkYellow 
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Gray 
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore DarkGray 
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Blue 
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Green  
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Cyan  
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Red 
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Magenta  
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore Yellow  
        Start-Sleep -millisecond 50
        Write-Host "Good luck to you all the time" -fore White 
        Start-Sleep -millisecond 50
    }
    exit
}
Write-Host "   - - EXIT - -   "
exit
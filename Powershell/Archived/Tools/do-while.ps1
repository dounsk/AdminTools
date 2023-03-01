& { do
{
    Write-Host "-------------------"
    Write-Host "   - - Timer - -   "
    Write-Host $(Get-Date -Format "    yyyy-MM-dd") -fore green 
    Write-Host $(Get-Date -Format "     HH:mm:ss") -fore green
    Write-Host "-------------------"
    Start-Sleep -second 1
    $c = "$(Get-Date -Format "mm")"
} while ($c -le  36) }
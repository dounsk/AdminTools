$c = "$(Get-Date -Format "mm")"
while($c -le 57)
{
    $c = "$(Get-Date -Format "mm")"
    Write-Host "-------------------"
    Write-Host ">> Time Reminder <<"
    Write-Host $(Get-Date -Format "    yyyy-MM-dd") -fore green
    Write-Host $(Get-Date -Format "     HH:mm:ss") -fore green
    Write-Host "-------------------"
    #Start-Sleep -minute 1
    Start-Sleep -second 1
    cls
}
$m = "$(Get-Date -Format "mm")"
while($m -ne 01)
{
    $m = "$(Get-Date -Format "mm")"
    $s = "$(Get-Date -Format "ss")"
    if($s -eq $s)
    {
    $s = "$(Get-Date -Format "ss")"
    Write-Host "      Last 2 Minutes"
    Write-Host "-----------------------------"
    Write-Host "YYYY-MM-DD  HH:MM   ss    fff"
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host $(Get-Date -Format "yyyy-MM-dd  HH:mm  <ss>  [fff]") -fore green
    Start-Sleep -millisecond 50
    Write-Host "+  +  +  +  +  +  +  +  +  +" -fore Yellow
    }
    Start-Sleep -millisecond 100
    cls
}
exit
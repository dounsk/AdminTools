$seconds = 10
1..$seconds |
ForEach-Object { $percent = $_ * 100 / $seconds;

Write-Progress -Activity Waiting -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent;

Start-Sleep -Seconds 1
}
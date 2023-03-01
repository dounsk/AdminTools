$OutPath = "$env:temp\summary.log"

Get-ChildItem -Path "C:\Users\demouser\Documents\Scripts\*.log" -Recurse -File |
    Sort-Object -Property LastWriteTime -Descending |
    Get-Content |
    Set-Content $OutPath

Invoke-Item -Path $OutPath
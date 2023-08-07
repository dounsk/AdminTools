# 设置扫描路径和目标文件名
$scanPath = "C:\temp\logs\"
$targetFiles = Get-ChildItem -Path $scanPath -Filter "*.log" | Where-Object {$_.CreationTime -ge (Get-Date).AddDays(-2)}
# 创建空的CSV文件
$outputFile = "C:\Users\tableau\Desktop\log_results.csv"
$csvHeader = "FileName, FilePath, Content"
$csvContent = @()
$csvContent += $csvHeader | Out-String | ConvertFrom-Csv
# 遍历每个目标文件
foreach ($file in $targetFiles) {
    Write-Host 'Scanning file' $file
    # 逐行检查文件内容
    $content = Get-Content -Path $file.FullName
    foreach ($line in $content) {
        if ($line -match '10\.96\.81\.103 \(lenovoad_zhangyong5\)') {
            $csvLine = [PSCustomObject]@{
                FileName = $file.Name
                FilePath = $file.FullName
                Content = $line
            }
            $csvContent += $csvLine
        }
        elseif ($line -match '10\.96\.81\.103 \(lenovoad_zhangyp10\)') {
            $csvLine = [PSCustomObject]@{
                FileName = $file.Name
                FilePath = $file.FullName
                Content = $line
            }
            $csvContent += $csvLine
        }
        elseif ($line -match 'PRC IT Database \(lenovoad_zhangyong5\)') {
            $csvLine = [PSCustomObject]@{
                FileName = $file.Name
                FilePath = $file.FullName
                Content = $line
            }
            $csvContent += $csvLine
        }
        elseif ($line -match 'CLT_data \(lenovoad_shenshuang2\)') {
            $csvLine = [PSCustomObject]@{
                FileName = $file.Name
                FilePath = $file.FullName
                Content = $line
            }
            $csvContent += $csvLine
        }
        elseif ($line -match 'FROM "PRC_REL_Presentation_Biz".dbo."V_Bo_Dashboard_BoInfo_Fyyear_3s_LTOP"') {
            $csvLine = [PSCustomObject]@{
                FileName = $file.Name
                FilePath = $file.FullName
                Content = $line
            }
            $csvContent += $csvLine
        }
    }
}
# 将结果保存到CSV文件
$csvContent | Export-Csv -Path $outputFile -NoTypeInformation
Write-Host "扫描完成，结果已保存到 $outputFile"
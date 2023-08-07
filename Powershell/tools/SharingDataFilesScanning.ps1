# 设置要扫描的根目录
$rootPath = "D:\Sharing_Data"
# 创建一个空的结果数组
$results = @()
# 递归扫描文件夹
Get-ChildItem -Path $rootPath -Recurse -File | ForEach-Object {
    # 获取文件夹地址、文件名称、以及文件的创建时间、最后修改时间、文件后缀
    $folderPath = $_.DirectoryName
    $fileName = $_.Name
    $creationTime = $_.CreationTime
    $lastWriteTime = $_.LastWriteTime
    $extension = $_.Extension
    
    # 创建一个自定义对象，并将其添加到结果数组中
    $result = New-Object -TypeName PSObject -Property @{
        FilePath = $folderPath
        FileName = $fileName
        CreationTime = $creationTime
        LastWriteTime = $lastWriteTime
        Extension = $extension
    }
    Write-Host 'Scanning' $folderPath':' $fileName
    $results += $result
}
# 检查是否已存在输出文件
$outputFile = "C:\Users\tableau\Desktop\$($env:COMPUTERNAME)_SharingDataFiles_$(Get-Date -Format 'yyyy-MM-dd.hhmm').csv"
if (Test-Path $outputFile) {
    # 如果存在输出文件，则将结果与现有内容合并，并保存为新的输出文件
    $existingResults = Import-Csv $outputFile
    $combinedResults = $existingResults + $results
    $combinedResults | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
} else {
    # 如果不存在输出文件，则直接保存结果为输出文件
    $results | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
}
Write-Host "扫描完成，并将结果保存到 $outputFile"
$APP_IDs = @(
    "2ec19add-bc5f-4ff0-a293-671a1f345d77"
    ,"51990abe-20b6-438d-819b-1204cb1434ce"
    ,"d7f9f0ee-0ded-48bc-aab6-a9507a314503"

)
# 日志文件目录路径
$logDirectory = "D:\QlikSenseSharedPersistence\ArchivedLogs\"
# 创建CSV文件并写入标题行
$outputFile = "C:\Users\tableau\Downloads\AppsLogScan_ServicesBusiness_$(Get-Date -Format 'yyyy-MM-dd.hhmm').csv"
"APP ID,logFile,logContent,created,lastModified" | Out-File -FilePath $outputFile -Encoding UTF8
# 扫描日志文件目录下的所有子文件夹
$subDirectories = Get-ChildItem -Path $logDirectory -Directory -Recurse
# 遍历子文件夹
foreach ($subDirectory in $subDirectories) {
    # 扫描子文件夹中的日志文件
    $logFiles = Get-ChildItem -Path $subDirectory.FullName -Filter "*.log" -File
    # 遍历日志文件
    foreach ($logFile in $logFiles) {
        # 检查日志文件标题是否包含任一APP_ID
        foreach ($APP_ID in $APP_IDs) {
            if ($logFile.Name -like "*$APP_ID*") {
                $logContent = Get-Content -Path $logFile.FullName -Tail 2
                $creationTime = $logFile.CreationTime
                $lastWriteTime = $logFile.LastWriteTime
                # 输出到CSV文件
                "$APP_ID,$logFile,$logContent,$creationTime,$lastWriteTime" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
                break
            }
        }
    }
}
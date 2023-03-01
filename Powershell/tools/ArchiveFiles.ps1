<#
 Author: Kui.Chen
 Date: 2023-02-17 13:41:45
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-17 15:39:32
 FilePath: \Scripts\Powershell\tools\ArchiveFiles.ps1
 Description: 使用PowerShell归档文件的脚本，归档目录是D:/temp，归档文件列表存储在D:/sheet1.xlsx sheet的B列，并生成每一个文件归档的日志的示例：
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>

# ----------------------------
# 注意❗ 需要修改文件和归档路径
# 从TXT导入归档文件路径的列表，请确保只包含需要清理的文件完全路径，例如“D:\temp\ArchivedLogs.log”
$FileList = Get-Content -Path "D:/1/temp/List of archived files.txt"
# 设置归档目录
$TargetDir = "D:/1/temp/"
# ---------------------------- 

    # 检测目录是否存在
    If (Test-Path $TargetDir) {
        # Check if the file exists
        If (Test-Path $FileList) {
            # 导出归档的操作日志
            $log = $TargetDir+"$env:COMPUTERNAME"+"_ArchivedLogs_$(Get-Date -Format 'yyyyMMddTHHmmss').csv"
            # 遍历目标文件列表
            Foreach ($File in $FileList) {
                # 检查文件是否存在
                If (Test-Path $File) {
                    # 文件存在 执行文件归档
                    # Move the file
                    Move-Item -Path $File -Destination $TargetDir -Force
                    # show the moving
                    Write-Host  "Successfully move $File to  $TargetDir " -fore Green
                    # Log the moving
                    $outcome = "Successfully"
                } Else {
                    # 文件不存在，显示报错
                    Write-Host "File $File not found" -fore Yellow
                    # Log the file not found
                    $outcome = "File not found"
                }
                # 生成CSV信息
                $Object = New-Object -TypeName PSObject -Property @{
                    Date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                    ComputerName = "$env:COMPUTERNAME"
                    ArchivedFile = $File
                    TargetDir = $TargetDir
                    Description = $outcome
                }
                # Export the object to the CSV file
                $Object | Export-Csv -Path $log -NoTypeInformation -Append
            }
            # 显示执行完成
            Write-Host "Execution complete 😀" 
            #打开归档文件夹
            Start-Process -FilePath $TargetDir
        } Else {
            # Throw an error
            Throw "File $FileList not found"
        }
    } Else {
        # Throw an error
        Throw "Directory $TargetDir not found"
    }
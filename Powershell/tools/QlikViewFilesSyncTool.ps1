<#
 Author       : Kui.Chen
 Date         : 2023-08-02 16:22:22
 LastEditors  : Kui.Chen
 LastEditTime : 2023-08-02 16:32:14
 FilePath     : \Scripts\Powershell\tools\QlikViewFilesSyncTool.ps1
 Description  : 
 Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# 创建窗口
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "QlikView Files Sync"
$Form.Size = New-Object System.Drawing.Size(800, 600)
$Form.StartPosition = "CenterScreen"
# 创建源文件选择组
$SourceFileGroup = New-Object System.Windows.Forms.GroupBox
$SourceFileGroup.Location = New-Object System.Drawing.Point(20, 20)
$SourceFileGroup.Size = New-Object System.Drawing.Size(760, 100)
$Form.Controls.Add($SourceFileGroup)
# 创建源文件多选框
$SourceFileCheckbox1 = New-Object System.Windows.Forms.RadioButton
$SourceFileCheckbox1.Location = New-Object System.Drawing.Point(20, 30)
$SourceFileCheckbox1.Size = New-Object System.Drawing.Size(720, 20)
$SourceFileCheckbox1.Text = "[PRD environment]   PRC Service Finance"
$SourceFileGroup.Controls.Add($SourceFileCheckbox1)
$SourceFileCheckbox2 = New-Object System.Windows.Forms.RadioButton
$SourceFileCheckbox2.Location = New-Object System.Drawing.Point(20, 60)
$SourceFileCheckbox2.Size = New-Object System.Drawing.Size(720, 20)
$SourceFileCheckbox2.Text = "[DEV environment]  Clyde"
$SourceFileGroup.Controls.Add($SourceFileCheckbox2)
# 创建源文件列表框
$FileList = New-Object System.Windows.Forms.ListBox
$FileList.Location = New-Object System.Drawing.Point(20, 140)
$FileList.Size = New-Object System.Drawing.Size(760, 200)
$Form.Controls.Add($FileList)

# 创建目标文件夹选择组
$DestinationFolderGroup = New-Object System.Windows.Forms.GroupBox
$DestinationFolderGroup.Location = New-Object System.Drawing.Point(20, 350)
$DestinationFolderGroup.Size = New-Object System.Drawing.Size(760, 160)
$Form.Controls.Add($DestinationFolderGroup)
# 创建目标文件夹多选框
$DestinationFolderCheckbox1 = New-Object System.Windows.Forms.RadioButton
$DestinationFolderCheckbox1.Location = New-Object System.Drawing.Point(20, 30)
$DestinationFolderCheckbox1.Size = New-Object System.Drawing.Size(720, 20)
$DestinationFolderCheckbox1.Text = "选择文件夹作为目标文件夹"
$DestinationFolderGroup.Controls.Add($DestinationFolderCheckbox1)
# 创建目标文件夹路径文本框
$DestinationFolderPathTextbox = New-Object System.Windows.Forms.TextBox
$DestinationFolderPathTextbox.Location = New-Object System.Drawing.Point(20, 60)
$DestinationFolderPathTextbox.Size = New-Object System.Drawing.Size(720, 20)
$DestinationFolderGroup.Controls.Add($DestinationFolderPathTextbox)
# 创建同步按钮
$SyncButton = New-Object System.Windows.Forms.Button
$SyncButton.Location = New-Object System.Drawing.Point(20, 520)
$SyncButton.Size = New-Object System.Drawing.Size(100, 30)
$SyncButton.Text = "同步"
$Form.Controls.Add($SyncButton)


$LogFolderPath = "E:\FilesSync\PRC Service Finance"
$LogFile = Join-Path -Path $LogFolderPath -ChildPath "PRCServiceFinanceSyncLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Starting synchronization process..." | Out-File -FilePath $LogFile -Append
# 源文件多选框的事件处理函数
$SourceFileCheckbox1.Add_CheckedChanged({
    if ($SourceFileCheckbox1.Checked) {
        $sourceFolder1 = "E:\QV\PRC Service Finance\"
        $FileList.Items.Clear()
        $files1 = Get-ChildItem -Path $sourceFolder1 -Recurse
        foreach ($file in $files1) {
            $FileList.Items.Add($file.FullName)
        }
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Source files from $sourceFolder1 have been loaded." | Out-File -FilePath $LogFile -Append
    }
})
$SourceFileCheckbox2.Add_CheckedChanged({
    if ($SourceFileCheckbox2.Checked) {
        $sourceFolder2 = "\\Pekwnqlik01\qv\Clyde\"
        $FileList.Items.Clear()
        $files2 = Get-ChildItem -Path $sourceFolder2 -Recurse
        foreach ($file in $files2) {
            $FileList.Items.Add($file.FullName)
        }
        Write-Output  "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Source files from $sourceFolder2 have been loaded." | Out-File -FilePath $LogFile -Append
    }
})
# 目标文件夹多选框的事件处理函数
$DestinationFolderCheckbox1.Add_CheckedChanged({
    if ($DestinationFolderCheckbox1.Checked) {
        $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $Result = $FolderBrowserDialog.ShowDialog()
        if ($Result -eq "OK") {
            $DestinationFolderPathTextbox.Text = $FolderBrowserDialog.SelectedPath
            Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Destination folder has been selected: $($FolderBrowserDialog.SelectedPath)" | Out-File -FilePath $LogFile -Append
        }
    }
})
# 同步按钮的事件处理函数
$SyncButton.Add_Click({
    $destinationFolder = $DestinationFolderPathTextbox.Text
    if ([System.IO.Directory]::Exists($destinationFolder)) {
        $selectedFiles = $FileList.SelectedItems
        foreach ($file in $selectedFiles) {
            $fileName = $file.ToString()
            Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Copying file from Source $fileName to destination $destinationFolder" | Out-File -FilePath $LogFile -Append
            Copy-Item -Path $fileName -Destination $destinationFolder
        }
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') File synchronization completed successfully." | Out-File -FilePath $LogFile -Append
        [System.Windows.Forms.MessageBox]::Show("文件同步完成。")
    } else {
        Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Destination folder does not exist. Please choose a valid folder." | Out-File -FilePath $LogFile -Append
        [System.Windows.Forms.MessageBox]::Show("目标文件夹不存在，请重新选择。")
    }
    powershell Invoke-Item $LogFolderPath
})
# 显示窗口
$Form.ShowDialog() | Out-Null
$scripts = @(
    "C:\ProgramData\Admintools\get\qs_service_status.pyw"
    "C:\ProgramData\Admintools\get\nprinting_service_status.pyw"
    "C:\ProgramData\Admintools\get\server_usage.pyw"
    "C:\ProgramData\Admintools\get\scheduled_task_executions.pyw"
    "C:\ProgramData\Admintools\get\scheduled_task_executions_dev.pyw"
    # "C:\ProgramData\Admintools\get\other_script.pyw -option1 value1 -option2 value2"

)
# 循环遍历数组，执行每个 Python 脚本并隐藏窗口
foreach($script in $scripts) {
    # 创建一个 PowerShell 对象，用于执行命令并隐藏窗口
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = "D:\WorkSpace\Env\Python_Env\wrm\Scripts\python.exe"
    $ps.Arguments = $script
    $ps.WindowStyle = "Hidden"
    # 使用 Start 方法启动进程并隐藏窗口
    [System.Diagnostics.Process]::Start($ps) | Out-Null
}
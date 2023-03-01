<#
 Author: Kui.Chen
 Date: 2023-02-17 10:10:02
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-17 11:46:28
 FilePath: \Scripts\Powershell\tools\Invoke-Command.ps1
 Description: 远程执行ps脚本的几种方式 Invoke-Command
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>

# 1. 携带本地执行变量发送至远程计算机执行
    # 本地运行的脚本信息
    $localpc = $env:COMPUTERNAME 
    # 预设身份验证信息
    $credential = New-Object System.Management.Automation.PSCredential("lenovo\tableau", (ConvertTo-SecureString "wixj-2342" -AsPlainText -Force))
    # 使用-ArgumentList 携带参数发送至远程计算机执行
    Invoke-Command -ComputerName "SYPQLIKSENSE18" -Credential $credential -ScriptBlock { Write-Host 'Invoke Command by '$localpc  -fore green } -ArgumentList $localpc 

#   换一种格式 👇

    # Set the credentials
    $Username = "lenovo\tableau"
    $Password = ConvertTo-SecureString -String "wixj-2342" -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Username, $Password)
    # Invoke the command
    Invoke-Command -ComputerName "sypqliksense18" -Credential $Credential -ScriptBlock {
        # Your command here
        Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    }

# 2. 使用ms pwoershell运行的身份发送命令到远程计算机，优点不用预设账户密码，缺点依赖登录的用户信息，可能遇执行权限不足
    $parameters = @{
        ComputerName = "sypqliksense15", "sypqliksense18","sypqliksense17" # 远程计算机名
        ConfigurationName = 'microsoft.powershell' # 身份验证信息
        ScriptBlock = {        # 运行脚本

        $date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $Hostname = $env:COMPUTERNAME
        $IP = (ipconfig|select-string "IPv4"|out-string).Split(":")[1]
        Write-Host $date $Hostname $IP
        
        }
    }
    Invoke-Command @parameters


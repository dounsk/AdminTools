<#
 Author       : Kui.Chen
 Date         : 2023-03-13 16:20:15
 LastEditors  : Kui.Chen
 LastEditTime : 2023-03-13 16:20:40
 FilePath     : \Scripts\Powershell\tools\ftpupload.ps1
 Description  : 
 Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
function Upload-CTXFToFTP {
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]$FTPServer,
        [Parameter(Mandatory=$true,Position=1)]
        [string]$DirPath,
        [Parameter(Mandatory=$true,Position=2)]
        [string]$Username,
        [Parameter(Mandatory=$true,Position=3)]
        [string]$Password
    )
    
    $FTPIP, $FTPPort = $FTPServer.Split(":")
    $FTPPath = "ftp://${Username}:${Password}@${FTPIP}:${FTPPort}/Nodes/${env:COMPUTERNAME}/ArchivedLogs/"
    
    # 遍历目标文件夹下的文件，并上传到FTP服务器
    foreach ($item in (Get-ChildItem $DirPath -Filter "*.ctxf")) {
        Write-Host $env:COMPUTERNAME "Uploading: $($item.Name) to $FTPServer/Nodes/${env:COMPUTERNAME}/ArchivedLogs/..." -ForegroundColor Green

        $FTPAbsolutePath = "$($FTPPath)$($item.Name)"
        $LocalAbsolutePath = $item.FullName

        try {
            $WebClient = New-Object System.Net.WebClient
            $WebClient.UploadFile($FTPPath + $item.Name, $item.FullName)
        }
        catch {
            Write-Error "Failed to upload file $($item.Name): $_"
        }
    }
}

# 调用函数
$FTPServer = "10.122.36.118:22"
$DirPath = "C:\ProgramData\Qlik\Sense\Engine\CrashDumps\" 
$Username = 'Qlikplatform'
$Password = 'Qlikplatform'
Upload-CTXFToFTP -FTPServer $FTPServer -DirPath $DirPath -Username $Username -Password $Password
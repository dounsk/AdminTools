'''
Author       : Kui.Chen
Date         : 2023-03-06 11:50:38
LastEditors  : Kui.Chen
LastEditTime : 2023-03-13 11:23:13
FilePath     : \Scripts\Python\win_rm\win_rm.py
Description  : 使用python winrm库远程连接Windows服务器的简单示例
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import winrm

def remote_server(remote_host, command): 
    remote_username = 'tableau'
    remote_password = 'wixj-2342'
    session         = winrm.Session('http://'+remote_host+':5985/wsman', 
                            auth                   = (remote_username, remote_password),
                            transport              = 'ntlm',
                            server_cert_validation = 'ignore')
    # CMD
    # result = session.run_cmd(command) 
    # Powershell
    result = session.run_ps(command) 
    print (result.std_out.decode())
    # return result.std_out.decode()

host = '10.122.36.129'
cmd  = """
$hostFile = "C:\Windows\System32\drivers\etc\hosts"

$fileContent = @"
# Hostlist \r\n
192.168.0.1     www.example.com \r\n
192.168.0.2     www.test.com \r\n
"@

Add-Content -Path $hostFile -Value $fileContent
"""

if __name__ == '__main__':
    remote_server(host, cmd)
    
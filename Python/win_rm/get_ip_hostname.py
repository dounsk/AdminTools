
'''
Author       : Kui.Chen
Date         : 2023-03-13 11:46:20
LastEditors  : Kui.Chen
LastEditTime : 2023-04-19 14:40:37
FilePath     : \Scripts\Python\win_rm\get_ip_hostname.py
Description  : 批量获取IP对应的hostname
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
    result = session.run_ps(command) 
    print (result.std_out.decode("utf-8"))
    # return result.std_out.decode()

node = "10.122.27.39"
ps1  = """

$ipList = "10.122.27.37", "10.122.27.38", "10.122.27.39", "10.122.27.1", "10.122.27.2", "10.122.27.3", "10.122.27.4", "10.122.27.5"

foreach ($ip in $ipList) {
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        $hostname = (Resolve-DnsName -Name $ip -ErrorAction SilentlyContinue | Select-Object -ExpandProperty NameHost)
        Write-Host "$ip / $hostname" -ForegroundColor Green
    } else {
        Write-Host "$ip / Unreachable" -ForegroundColor Red
    }
}

"""

if __name__ == '__main__':
    remote_server(node, ps1)
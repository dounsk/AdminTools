'''
Author       : Kui.Chen
Date         : 2023-03-13 11:46:20
LastEditors  : Kui.Chen
LastEditTime : 2023-03-31 14:07:28
FilePath     : \Scripts\Python\win_rm\md_win_host copy.py
Description  : 循环修改Windows host名单
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
    # ^ --- Run commands ---
    # result = session.run_cmd(command) 
    # ^ --- Run Powershell ---
    result = session.run_ps(command) 
    print (result.std_out.decode("utf-8"))
    # return result.std_out.decode()

nodes = [
# "10.122.27.37",

"10.122.27.1",
"10.122.27.3",
"10.122.27.5",
"10.122.27.38",
"10.122.27.39"
]
ps1  = """
# Stop-Service -NameQlikLoggingService
# Stop-Service -NameQlikSenseEngineService
# Stop-Service -NameQlikSensePrintingService
# Stop-Service -NameQlikSenseProxyService
# Stop-Service -NameQlikSenseRepositoryService
# Stop-Service -NameQlikSenseSchedulerService
# Stop-Service -NameQlikSenseServiceDispatcher

Get-Service -Name Qlik* | Format-Table -Property Status, Name
"""

if __name__ == '__main__':
    for node in nodes:
        remote_server(node, ps1)
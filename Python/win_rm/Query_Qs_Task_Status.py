'''
Author       : Kui.Chen
Date         : 2023-03-06 11:50:38
LastEditors  : Kui.Chen
LastEditTime : 2023-06-05 16:31:35
FilePath     : \Scripts\Python\win_rm\Query_Qs_Task_Status.py
Description  : 远程调用130服务器上 pgsql 查询脚本获取Qlik Sense task 运行状态
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
    result = session.run_cmd(command) 
    # Powershell
    # result = session.run_ps(command) 
    print (result.std_out.decode())
    # return result.std_out.decode()

host = '10.122.36.112'
# Query
cmd  = r'hostname'

if __name__ == '__main__':
    remote_server(host, cmd)
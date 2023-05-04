'''
Author       : Kui.Chen
Date         : 2023-03-06 11:50:38
LastEditors  : Kui.Chen
LastEditTime : 2023-04-24 14:44:14
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

host = '10.122.36.184'
cmd  = r" mysqldump -u root -p'mysql2023' qliksense > qliksense_backup_10.122.36.184_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql "

if __name__ == '__main__':
    remote_server(host, cmd)
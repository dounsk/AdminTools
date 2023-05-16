#python 

``` python
def remote_server(remote_host, command):

    # 执行 Windows 远程命令
    remote_username = 'tableau'
    remote_password = 'wixj-2342'
    session         = winrm.Session('http://'+remote_host+':5985/wsman',
                        auth=(remote_username, remote_password),
                        transport='ntlm',
                        server_cert_validation='ignore')
    result = session.run_ps(command)
    # result = session.run_cmd(command)
    return result.std_out.strip()


def execute_local_server(command):
    # 在本地服务器获取信息
    # 创建power shell子程序，不显示命令窗口
    process = subprocess.Popen(['powershell.exe', '-Command', ps1], stdout=subprocess.PIPE, creationflags=subprocess.CREATE_NO_WINDOW)
    result = process.communicate()[0].decode('utf-8').strip()
    implement(result)
```
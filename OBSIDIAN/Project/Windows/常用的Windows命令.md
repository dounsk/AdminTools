  
以下是一些常用的Windows命令，可以获取服务器的信息：

1.  获取计算机名

```
hostname
```

2.  获取操作系统版本和服务包

```
systeminfo | findstr /c:"OS Name" /c:"OS Version" /c:"OS Configuration" /c:"OS Build" /c:"System Type" /c:"Hotfix(s)" /c:"Available Physical Memory" /c:"Total Physical Memory" /c:"Domain"
```

3.  获取CPU信息

```
wmic cpu get name, caption, deviceid, maxclockspeed, currentclockspeed, numberofcores, numberoflogicalprocessors
```

4.  获取内存信息

```
systeminfo | findstr /c:"Total Physical Memory" /c:"Available Physical Memory"
```

5.  获取磁盘信息

```
wmic diskdrive get name, model, size, interfacetype
```

6.  获取网络适配器信息

```
wmic nic get name, macaddress, netconnectionid, speed
```

7.  获取系统启动时间

```
systeminfo | findstr /c:"System Boot Time"
```

8.  获取当前时间

```
echo %time%
```

您可以在Python中使用WinRM库执行这些命令，以获取远程服务器的信息。以下是一个示例代码，可以获取计算机名、操作系统版本和服务包、CPU信息、内存信息、磁盘信息、网络适配器信息、系统启动时间和当前时间：

```python
import winrm

# 定义远程主机的名称或IP地址
remote_host = 'your_remote_host'

# 定义远程主机的账户和密码
remote_username = 'your_remote_username'
remote_password = 'your_remote_password'

# 创建WinRM连接对象
session = winrm.Session('http://'+remote_host+':5985/wsman', auth=(remote_username, remote_password), transport = 'ntlm', server_cert_validation = 'ignore')
 
# 获取计算机名
result = session.run_cmd('hostname')
print('Machine Name: ' + result.std_out.decode().strip())

# 获取操作系统版本和服务包
result = session.run_cmd('systeminfo | findstr /c:"OS Name" /c:"OS Version" /c:"OS Configuration" /c:"OS Build" /c:"System Type" /c:"Hotfix(s)" /c:"Available Physical Memory" /c:"Total Physical Memory" /c:"Domain"')
print('OS Information:\n' + result.std_out.decode().strip())

# 获取CPU信息
result = session.run_cmd('wmic cpu get name, caption, deviceid, maxclockspeed, currentclockspeed, numberofcores, numberoflogicalprocessors')
print('CPU Information:\n' + result.std_out.decode().strip())

# 获取内存信息
result = session.run_cmd('systeminfo | findstr /c:"Total Physical Memory" /c:"Available Physical Memory"')
print('Memory Information:\n' + result.std_out.decode().strip())

# 获取磁盘信息
result = session.run_cmd('wmic diskdrive get name, model, size, interfacetype')
print('Disk Information:\n' + result.std_out.decode().strip())

# 获取网络适配器信息
result = session.run_cmd('wmic nic get name, macaddress, netconnectionid, speed')
print('Network Adapter Information:\n' + result.std_out.decode().strip())

# 获取系统启动时间
result = session.run_cmd('systeminfo | findstr /c:"System Boot Time"')
print('System Boot Time: ' + result.std_out.decode().strip().split(':')[1].strip())

# 获取当前时间
result = session.run_cmd('echo %time%')
print('Current Time: ' + result.std_out.decode().strip())
```
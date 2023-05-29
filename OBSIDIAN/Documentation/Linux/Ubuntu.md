
要修改`/etc/ansible/ansible.cfg`文件，可以使用任何文本编辑器进行编辑。如果你使用的是命令行，可以使用`vim`、`nano`等编辑器。以下是使用`vim`编辑的示例：

```
 sudo vim /etc/ansible/ansible.cfg
```

你可以修改任何你需要的配置选项并保存文件。请注意，对于某些更改，可能需要重启Ansible服务才能生效。 以下是配置Ansible管理Windows的示例： 在`/etc/ansible/hosts`文件中添加Windows主机的IP地址或主机名（如果使用DNS解析），并将其分组，例如：

```
 [windows]
192.168.1.100
```

在`/etc/ansible/ansible.cfg`文件中，确保以下配置选项被打开：

```
 [defaults]
inventory = /etc/ansible/hosts
remote_user = Administrator
transport = winrm
```

请注意，如果你使用的是不同的Windows账户，你需要将`remote_user`选项设置为正确的用户名。 接下来，你需要在Windows主机上安装`winrm`插件。你可以使用以下命令在PowerShell中安装它：

```
Invoke-WebRequest https://github.com/ansible/ansible/raw/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
./ConfigureRemotingForAnsible.ps1 -EnableCredSSP -Force
```

这将为Ansible配置WinRM插件，允许使用CredSSP进行身份验证。 最后，你需要在`/etc/ansible/group_vars/windows.yml`文件中添加以下内容：

```
ansible_user: Administrator
ansible_password: your_password_here
ansible_port: 5985
ansible_connection: winrm
ansible_winrm_transport: basic
ansible_winrm_server_cert_validation: ignore
```

确保将`ansible_password`选项设置为正确的Windows账户密码，并将`ansible_port`选项设置为WinRM端口（默认端口为5985）。 现在，你可以在Ansible中使用`windows`组的主机，并使用指定的Windows账户和密码进行身份验证。以下是一个简单的示例：

```
 - name: Run a command on Windows
  hosts: windows
  tasks:
    - name: Run command
      win_command: dir
```

这将在`windows`组中的所有Windows主机上运行`dir`命令。
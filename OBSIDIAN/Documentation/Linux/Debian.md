1. `apt-get`：用于安装、升级和卸载软件包。
2. `dpkg`：用于管理本地软件包，可以使用该命令安装、卸载、查询软件包信息等。
3. `ls`：列出目录下的文件和子目录。
4. `cd`：切换当前工作目录。
5. `mkdir`：创建一个新目录。
6. `rm`：删除文件或目录。
7. `cp`：复制文件或目录。
8. `mv`：移动或重命名文件或目录。
9. `chmod`：修改文件或目录的权限。

## 挂载Windows文件系统
%% sudo mount -t cifs //Windows主机名/共享文件夹名 /挂载点 -o username=Windows用户名,password=Windows用户密码,iocharset=utf8,sec=ntlm %%
```
sudo mount -t drvfs '\\DESKTOP-GFM9T2O\Users\douns\OneDrive - 8088\Scripts' /home/kuii/scripts
```
## 安装python 

```
sudo apt update
sudo apt install python3

python3 --version
```


将Python添加到环境变量中：

1. 打开`~/.bashrc`文件，该文件包含系统启动时执行的基本bash shell命令：
```
nano ~/.bashrc
```
2. 在文件末尾添加以下两行代码：
```
export PATH="$PATH:/usr/bin/python3"
alias python='/usr/bin/python3'
```
3. 保存并关闭文件(ctrl+X)，然后重新启动bash shell以使更改生效：
```
source ~/.bashrc
```
4. 最后，您可以使用以下命令验证Python 3是否已成功添加到环境变量中：
```
python --version
```

如果Python 3版本号显示正常，则说明添加到环境变量成功。

安装pip

```
sudo apt update
sudo apt install python3-pip
pip3 --version
```

## 执行计划任务

```nano
sudo crontab -e

* * * * * /path/to/command arg1 arg2
```

	星号分别表示分钟、小时、日、月、星期几，可以使用数字或星号来指定。例如，`* * * * *`表示每分钟执行一次，`0 * * * *`表示每小时执行一次，`0 0 * * *`表示每天零点执行一次，`0 0 * * 1`表示每周一零点执行一次。 `/path/to/command`表示要执行的脚本或命令，`arg1 arg2`表示要传递给脚本或命令的参数，如果没有参数可以省略。

示例每周的周一到周五的上午10点运行
```
0 10 * * 1-5 /usr/bin/python3 /home/kuii/scripts/Python/ScheduledTasks/tasks/daily_zhihu.pyw
```
	其中，`0 10 * * 1-5`表示在每周的周一到周五的上午10点执行一次，`/usr/bin/python3`指定了Python解释器的路径，`/home/kuii/scripts/Python/ScheduledTasks/tasks/daily_zhihu.pyw`是要执行的Python脚本的路径。

查看计划任务执行列表 ’ sudo crontab -l‘

## 将 mount 添加到Debian的开机自动运行中：

	1. 打开终端并输入'sudo visudo' 命令以编辑sudoers文件。
	
		如果您还没有配置过sudoers文件，请在文件末尾添加以下行：
		<your_username> ALL=(ALL) NOPASSWD: /bin/mount -t drvfs
		
		保存并退出sudoers文件。
	
	2. 打开终端并输入'sudo crontab -e'命令以编辑cron表。
	
		在文件末尾添加以下行：
		@reboot sudo mount -t drvfs '\\DESKTOP-GFM9T2O\Users\douns\OneDrive - 8088\Scripts' /home/kuii/scripts
		
		保存并退出cron表。
	现在，当您启动Debian时，sudo mount -t drvfs命令将自动运行并挂载您指定的设备和分区。
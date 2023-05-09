### （1）临时使用：  

可以在使用pip的时候，加上参数-i和镜像地址

```url
（1）阿里云 http://mirrors.aliyun.com/pypi/simple/  
（2）豆瓣 http://pypi.douban.com/simple/  
（3）清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/  
（4）中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/  
（5）华中科技大学 http://pypi.hustunique.com/
```

```
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tkcalendar
```

### （2）永久修改：

- a Linux下，修改 ~/.pip/pip.conf (没有就创建一个文件夹及文件。文件夹要加“.”，表示是隐藏文件夹)  
内容如下：

```
[global]  
index-url = https://pypi.tuna.tsinghua.edu.cn/simple  
[install]  
trusted-host = https://pypi.tuna.tsinghua.edu.cn
```

- b Windows下，直接在user目录中创建一个pip目录，如：`C:\Users\xx\pip`，然后新建文件`pip.ini`，即 `%HOMEPATH%\pip\pip.ini`，在 `pip.ini` 文件中输入以下内容（以豆瓣镜像为例）：

```
[global]  
index-url = http://pypi.douban.com/simple  
[install]  
trusted-host = pypi.douban.com
```
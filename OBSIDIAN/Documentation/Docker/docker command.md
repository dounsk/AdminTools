1.  `docker run`: 在新容器中运行一个命令。例如：`docker run ubuntu` 将在新的Ubuntu容器中运行一个命令。
2.  `docker ps`: 列出所有正在运行的容器。例如：`docker ps` 将列出所有正在运行的容器及其相关信息。
3.  `docker images`: 列出所有本地镜像。例如：`docker images` 将列出所有已下载到本地计算机中的镜像及其相关信息。
4.  `docker pull`: 从Docker仓库中拉取一个镜像。例如：`docker pull ubuntu` 将从Docker Hub中拉取最新版本的Ubuntu镜像。
5.  `docker build`: 从Dockerfile构建一个新的镜像。例如：`docker build -t my-image .` 将使用位于当前目录的Dockerfile构建一个名为`my-image`的新镜像。
6.  `docker stop`: 停止一个正在运行的容器。例如：`docker stop my-container` 将停止名为`my-container`的容器。
7.  `docker start`: 启动一个停止的容器。例如：`docker start my-container` 将启动名为`my-container`的容器。
8.  `docker rm`: 删除一个容器。例如：`docker rm my-container` 将删除名为`my-container`的容器。
9.  `docker rmi`: 删除一个本地镜像。例如：`docker rmi my-image` 将删除名为`my-image`的本地镜像。
10.  `docker exec`: 在正在运行的容器中执行一个命令。例如：`docker exec my-container ls -l` 将在名为`my-container`的容器中运行`ls -l`命令。
11.  `docker logs`: 查看一个容器的日志输出。例如：`docker logs my-container` 将输出名为`my-container`的容器的日志。
12.  `docker network`: 管理Docker网络。例如：`docker network ls` 将列出所有可用的Docker网络。
13.  `docker volume`: 管理Docker卷。例如：`docker volume ls` 将列出所有可用的Docker卷。
14.  `docker-compose`: 使用Docker Compose管理多容器应用程序。例如：`docker-compose up` 将启动Docker Compose配置中定义的所有容器。 
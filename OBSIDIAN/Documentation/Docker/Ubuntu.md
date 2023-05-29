#docker
1. 打开终端或命令行工具，并输入以下命令以在Ubuntu镜像中启动一个新容器：
    
    ```
	docker run -it --name my-ubuntu ubuntu
    ```
    
    这将在Ubuntu镜像中启动一个新容器，并将终端连接到容器的标准输入和输出。该容器将命名为`my-ubuntu`。
    
2.  等待一段时间，直到容器启动并出现`root@<container-id>:/#`的提示符。这表明你已成功连接到运行的Ubuntu容器。
    
3.  现在你可以在容器中运行任何Ubuntu命令。例如，你可以在容器中运行以下命令来更新软件包列表：
    
    ```
	apt-get update
    ```
    
4.  你还可以在容器中安装任何Ubuntu软件包。例如，可以使用以下命令安装`nginx` Web服务器：
    
    ```
    apt-get install nginx
    ```
    
5.  当你完成容器中的操作时，可以使用以下命令退出容器并停止它：
    
    ```
    exit
    docker stop my-ubuntu
    ```
    
    这将退出容器并停止它。如果你想再次启动该容器并连接到终端，请使用以下命令：
    
    ```
    docker start my-ubuntu
    docker attach my-ubuntu
    ```
    
    这将重新启动容器，并再次连接到其标准输入和输出。 注意：请注意，这些步骤假定你已经安装了Docker Desktop，并已经成功拉取了Ubuntu镜像。如果你还没有安装Docker Desktop或拉取Ubuntu镜像，请先完成这些步骤。
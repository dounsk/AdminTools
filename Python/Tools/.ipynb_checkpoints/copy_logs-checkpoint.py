'''
Author       : Kui.Chen
Date         : 2023-05-22 10:55:31
LastEditors  : Kui.Chen
LastEditTime : 2023-05-25 10:14:26
FilePath     : \Scripts\Python\Tools\copy_logs.py
Description  : 拷贝共享目录中最近修改时间在n天内的日志文件
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import os
import shutil
from datetime import datetime, timedelta
# 定义需要查询的所有app_id
app_ids = ["8d8c1658-acb5-4ae2-bfb5-e1131d1068d0", "ca78d8d1-268d-4208-af91-701e62580c6c"]
# 定义需要查询的文件存储根目录和下载目录
root_directory     = '//10.122.84.180/QlikSenseSharedPersistence/ArchivedLogs/'
download_directory = 'C://Users//douns//Downloads//Copy'
# 计算3个月前的时间戳
three_months_ago = datetime.now() - timedelta(days=7)
three_months_ago_timestamp = three_months_ago.timestamp()
# 遍历所有节点
nodes = ["sypqliksense05", "sypqliksense06", "sypqliksense07", "sypqliksense08", "sypqliksense17"]
for node in nodes:
    # 构造需要扫描的目录
    scan_directory = os.path.join(root_directory, node, 'Script')
    
    # 遍历该目录下的所有文件
    for file_name in os.listdir(scan_directory):
        # 判断文件名是否包含任何一个app_id
        if any(app_id in file_name for app_id in app_ids):
            # 构造文件完整路径
            file_path = os.path.join(scan_directory, file_name)
            
            # 获取文件最后修改时间
            last_modified = os.path.getmtime(file_path)
            
            # 判断文件最后修改时间是否在3个月内
            if last_modified >= three_months_ago_timestamp:
                # 构造文件需要拷贝到的目标路径
                target_path = os.path.join(download_directory, file_name)
                print ("Copy " + file_name + " to " + download_directory)
                # 拷贝文件到目标路径
                shutil.copy(file_path, target_path)
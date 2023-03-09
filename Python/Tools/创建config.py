'''
Author       : Kui.Chen
Date         : 2023-03-02 17:06:50
LastEditors  : Kui.Chen
LastEditTime : 2023-03-07 14:37:50
FilePath     : \Scripts\Python\Tools\创建config.py
Description  : 创建config.ini文件以供其他程序读取
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import configparser
import platform
import datetime

def config(file_path):
    # 获取计算机信息
    System_info = {
        'version'    : platform.version(),
        'system_name': platform.system(),
        'node_name'  : platform.node(),
        'processor'  : platform.processor(),
        'release'    : platform.release()
    }
    current_time = datetime.datetime.now()
    # 写入配置文件
    config = configparser.ConfigParser()
    config['SystemInfo'] = System_info
    config['Time'] = {'current_time': current_time}

    with open(file_path, 'w') as configfile:
        config.write(configfile)

if __name__ == "__main__":
    file_path = "Python\\temp\\config.ini"
    config(file_path)
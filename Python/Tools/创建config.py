'''
Author       : Kui.Chen
Date         : 2023-03-02 17:06:50
LastEditors  : Kui.Chen
LastEditTime : 2023-04-17 14:02:06
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
        'version'       : 'v1.0',
        'encoding'      : 'utf8',
        'configuration' : 'Get the data',
        'startup'       : 'collector',
        'environment'   : 'Windows',
        'culture'       : 'neutral',
        'enable'        : 'true',
        'publicKeyToken': 'UsC4pDVAZ@z*&W'
    }

    data_connection = {
        'SqlClient': 'mysql',
        'host'     : '10.122.36.184',
        'port'     : '3306',
        'database' : 'QlikSense'
    }

    # 写入配置文件
    config = configparser.ConfigParser()
    config['system_info'] = System_info
    config['data_connection'] = data_connection

    with open(file_path, 'w') as configfile:
        config.write(configfile)

if __name__ == "__main__":
    file_path = "config.ini"
    config(file_path)
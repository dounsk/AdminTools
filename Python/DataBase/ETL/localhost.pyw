'''
Author       : Kui.Chen
Date         : 2023-04-21 09:51:18
LastEditors  : Kui.Chen
LastEditTime : 2023-04-23 10:45:58
FilePath     : \Scripts\Python\DataBase\ETL\qs_service_status_localhost.pyw
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import pymysql
import subprocess
import configparser

def connect():
    '''连接MySQL数据库'''
    try:
        config = configparser.ConfigParser()
        config.read('C:/ProgramData/Admintools/get/config.ini')
        db = pymysql.connect(
            host    = config.get('data_connection', 'host'),
            port    = int(config.get('data_connection', 'port')),
            user    = config.get('system_info', 'startup'),
            passwd  = config.get('system_info', 'configuration'),
            db      = config.get('data_connection', 'database'),
            charset = config.get('system_info', 'encoding')
            )
        return db
    except Exception:
        raise Exception("Failed")

def implement(sql):
    # 连接数据库
    conn = connect()
    # 获取游标
    cursor = conn.cursor()
    # 逐一执行SQL语句
    for line in sql.splitlines():
        if line.strip():
            cursor.execute(line.strip())
    # 提交事务并关闭连接
    conn.commit()
    cursor.close()
    conn.close()

ps1  = """
# 获取所有以Qlik开头的服务
$services = Get-Service | Where-Object {$_.Name -like "Qlik*"}
# 循环获取服务运行状态并生成更新语句
foreach ($service in $services) {
    $machineName = $env:COMPUTERNAME
    $serviceName = $service.Name
    $status = if ($service.StartType -eq "Disabled") {0} elseif ($service.Status -eq "Running") {1} else {2}
    $sql = "UPDATE qs_service_status SET status=$status, update_time=NOW() WHERE machine_name='$machineName' AND service_name='$serviceName'"
    $sql
}
"""

if __name__ == '__main__':
    # run powershell on localhost.
    process=subprocess.Popen(["powershell", ps1],stdout=subprocess.PIPE);
    result=process.communicate()[0]
    implement(result)
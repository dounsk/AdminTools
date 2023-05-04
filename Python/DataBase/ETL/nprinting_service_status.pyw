'''
Author       : Kui.Chen
Date         : 2023-04-23 09:54:36
LastEditors  : Kui.Chen
LastEditTime : 2023-04-25 16:18:55
FilePath     : \Scripts\Python\DataBase\ETL\nprinting_service_status.pyw
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import winrm
import pymysql
import configparser

def connect():
    '''连接MySQL数据库'''
    try:
        config = configparser.ConfigParser()
        # config.read('C:/ProgramData/Admintools/get/config.ini')
        config.read('Python\DataBase\ETL\config.ini')
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

def remote_server(remote_host, command): 
    remote_username = 'tableau'
    remote_password = 'wixj-2342'
    session         = winrm.Session('http://'+remote_host+':5985/wsman', 
                            auth                   = (remote_username, remote_password),
                            transport              = 'ntlm',
                            server_cert_validation = 'ignore')
    # ^ --- Run commands ---
    # result = session.run_cmd(command) 
    # ^ --- Run Powershell ---
    result = session.run_ps(command) 
    # print (result.std_out.decode("utf-8"))
    return result.std_out.decode()

nodes = [
## IP Address
"10.122.36.127",
"10.96.92.167"
]
ps1  = """
# # 获取所有以Qlik开头的服务
# $services = Get-Service | Where-Object {$_.Name -like "Qlik*"}
# # 循环获取服务运行状态并生成更新语句
# foreach ($service in $services) {
#     $machineName = $env:COMPUTERNAME
#     $serviceName = $service.Name
#     $status = if ($service.StartType -eq "Disabled") {0} elseif ($service.Status -eq "Running") {1} else {3}
#     $sql = "UPDATE qs_service_status SET status=$status, update_time=NOW() WHERE machine_name='$machineName' AND service_name='$serviceName'"
#     $sql
# }

# 获取服务状态并生成插入初始数据语句
$services = Get-Service | Where-Object {$_.Name -like "Qlik*"}

foreach ($service in $services) {
    $machineName = $env:COMPUTERNAME
    $serviceName = $service.Name
    $status = if ($service.StartType -eq "Disabled") {0} elseif ($service.Status -eq "Running") {1} else {3}
    $sql = "INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('$machineName', '$serviceName', $status, NOW());"
    $sql
}

"""

if __name__ == '__main__':
    for node in nodes:
        sql = remote_server(node, ps1)
        implement(sql)
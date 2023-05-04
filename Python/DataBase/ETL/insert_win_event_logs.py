'''
Author       : Kui.Chen
Date         : 2023-04-23 09:54:36
LastEditors  : Kui.Chen
LastEditTime : 2023-04-25 17:57:10
FilePath     : \Scripts\Python\DataBase\ETL\insert_win_event_logs.py
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
## IP Address 		    HostName	        Role
"10.122.36.100",	#	"SYPQLIKSENSE15"	[PRD] Proxy Engine 04"
"10.122.36.106",	#	"SYPQLIKSENSE18"	[PRD] Proxy Engine 05"
"10.122.36.107",	#	"SYPQLIKSENSE11"	[PRD] Proxy Engine 01"
"10.122.36.108",	#	"SYPQLIKSENSE12"	[PRD] Proxy Engine 02"
"10.122.36.109",	#	"SYPQLIKSENSE13"	[PRD] Proxy Engine 03"
"10.122.36.110",	#	"SYPQLIKSENSE14"	[PRD] API 02"
"10.122.36.119",	#	"SYPQLIKSENSE03"	[PRD] API 01"
# "10.122.36.118",	#	"SYPQLIKSENSE02"	[PRD] Sharing_Data"
# "10.122.84.180",	#	"SYPQLIKSENSE20"	[PRD] QlikSenseSharedPersistence"
"10.122.36.120",	#	"SYPQLIKSENSE04"	[PRD] Central Master & Scheduler Master"
"10.122.36.121",	#	"SYPQLIKSENSE05"	[PRD] Scheduler 05"
"10.122.36.122",	#	"SYPQLIKSENSE06"	[PRD] Central Candidate & Scheduler 01"
"10.122.36.123",	#	"SYPQLIKSENSE07"	[PRD] Scheduler 02"
"10.122.36.124",	#	"SYPQLIKSENSE08"	[PRD] Scheduler 03"
"10.122.36.220",	#	"SYPQLIKSENSE17"	[PRD] Scheduler 04"
"10.122.36.130",	#	"SYPQLIKSENSE19"	[PRD] SenseNP"
"10.122.36.111",	#	"PEKWPQLIK05"	    [DEV] Central Master & Scheduler Master"
"10.122.36.112",	#	"PEKWPQLIK06"	    [DEV] Central Candidate & Scheduler 01"
"10.122.36.114",	#	"PEKWPQLIK01"	    [DEV] Proxy Engine 01"
"10.122.36.115",	#	"PEKWPQLIK03"	    [DEV] Proxy Engine 02"
"10.122.36.116",	#	"PEKWPQLIK04"	    [DEV] Proxy Engine 03"
"10.122.36.128", 	#	"SYPQLIKSENSE09"	[DEV] Scheduler 02"
# "10.122.27.37",  #  "PEKWNQLIK07"
# "10.122.27.38",  #  "PEKWNQLIK08"
# "10.122.27.39",  #  "PEKWNQLIK09"
# "10.122.27.1",  #  "WIN-G7IG3TRA8E4"
# "10.122.27.3",  #  "WIN-ICR6696ONF4"
# "10.122.27.4",  #  "SHEWNQLIKRE"
# "10.122.27.5",  #  "WIN-54U2N8LPHD0"
# "10.122.27.222",  #  "SHEWNQUSC1"
# "10.122.27.223"  #  "SHEWNQUSC2"

]
ps1  = """
$logs = Get-EventLog -LogName application -EntryType Error -After (Get-Date).AddMinutes(-60) | Where-Object {$_.EventID -eq "300" }
# 如果 $logs 为空，则直接结束运行
if (!$logs) {
    # Write-Host "没有符合条件的日志，运行结束。"
    return
}
# 循环输出日志 并拼接成MySQL数据插入语句
foreach($log in $logs) {
    $time = $log.TimeGenerated
    $time = $time.ToString("yyyy-MM-dd HH:mm:ss")
    $entryType = $log.EntryType
    $source = $log.Source
    $instanceID = $log.InstanceID
    $message = $log.Message.replace("'","")
    $hostname = $log.MachineName
    $sql = "INSERT INTO win_event_logs (Time, EntryType, Source, InstanceID, Message, Hostname) VALUES ('$time', '$entryType', '$source', '$instanceID', '$message', '$hostname')"
    $sql
}
"""

if __name__ == '__main__':
    for node in nodes:
        sql = remote_server(node, ps1)
        implement(sql)
'''
Author       : Kui.Chen
Date         : 2023-04-21 09:51:18
LastEditors  : Kui.Chen
LastEditTime : 2023-04-21 09:51:37
FilePath     : \Scripts\Python\DataBase\ETL\mysql_localhost_insertinto.py
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
    '''执行SQL语句'''
    db = connect()
    cursor = db.cursor()
    for i in range(1):
        try:
            cursor.execute(sql)
            result = cursor.fetchone()
            db.commit()
            print('return:', result)
        except Exception:
            db.rollback()
            print("error")

    cursor.close()
    db.close()

ps1  = """
$server_ip = ((((ipconfig|select-string "IPv4"|out-string).Split(":")[1]) -split '\r?\n')[0] -split ' ')[1]

$ram_total = (Get-WmiObject -Class win32_OperatingSystem).TotalVisibleMemorySize/1mb
$ram_available = (Get-WmiObject -Class win32_OperatingSystem).FreePhysicalMemory/1mb

$disk_total_size_c = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq “C:” }).Size / 1gb
$disk_available_size_c = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq “C:” }).FreeSpace / 1gb 
$disk_total_size_d = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq “D:” }).Size / 1gb
$disk_available_size_d = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq “D:” }).FreeSpace / 1gb

$VALUES = "(null, '$env:COMPUTERNAME', '$server_ip', '$ram_total', '$ram_available', '$disk_total_size_c', '$disk_available_size_c', '$disk_total_size_d', '$disk_available_size_d', NOW());"

$sql = "INSERT INTO server_usage"
$sql += "(id, server_hostname, server_ip, memory_total, memory_available, disk_total_size_c, disk_available_size_c, disk_total_size_d, disk_available_size_d, date )"
$sql += "VALUES"
$sql += $VALUES

$sql
"""

if __name__ == '__main__':
    # run powershell on localhost.
    process=subprocess.Popen(["powershell", ps1],stdout=subprocess.PIPE);
    result=process.communicate()[0]
    implement(result)
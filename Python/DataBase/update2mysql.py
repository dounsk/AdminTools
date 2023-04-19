
import winrm
import pymysql

def connect():
    '''连接MySQL数据库'''
    try:
        db = pymysql.connect(
            host='10.122.36.184',
            port=3306,
            user='root',
            passwd='mysql2023',
            db='QlikSense',
            charset='utf8'
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
"10.122.36.120",	#	"SYPQLIKSENSE04"	[PRD] Central Master & Scheduler Master"
"10.122.36.121",	#	"SYPQLIKSENSE05"	[PRD] Scheduler 05"
"10.122.36.122",	#	"SYPQLIKSENSE06"	[PRD] Central Candidate & Scheduler 01"
"10.122.36.123",	#	"SYPQLIKSENSE07"	[PRD] Scheduler 02"
"10.122.36.124",	#	"SYPQLIKSENSE08"	[PRD] Scheduler 03"
"10.122.36.220",	#	"SYPQLIKSENSE17"	[PRD] Scheduler 04"
"10.122.36.111",	#	"PEKWPQLIK05"	    [DEV] Central Master & Scheduler Master"
"10.122.36.112",	#	"PEKWPQLIK06"	    [DEV] Central Candidate & Scheduler 01"
"10.122.36.114",	#	"PEKWPQLIK01"	    [DEV] Proxy Engine 01"
"10.122.36.115",	#	"PEKWPQLIK03"	    [DEV] Proxy Engine 02"
"10.122.36.116",	#	"PEKWPQLIK04"	    [DEV] Proxy Engine 03"
"10.122.36.128" 	#	"SYPQLIKSENSE09"	[DEV] Scheduler 02"
]
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
    for node in nodes:
        sql = remote_server(node, ps1)
        # print(sql)
        implement(sql)

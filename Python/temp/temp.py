'''
Author       : Kui.Chen
Date         : 2023-03-13 11:46:20
LastEditors  : Kui.Chen
LastEditTime : 2023-06-05 11:21:49
FilePath     : \Scripts\Python\win_rm\qliksense\rerun_qs_services.py
Description  : 多线程批量重启 Qlik Sense 服务
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import winrm
import datetime
import threading

import logging
import winrm
# 设置日志记录的配置
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
def remote_server(remote_host, command):
    remote_username = 'tableau'
    remote_password = 'wixj-2342'
    session = winrm.Session('http://'+remote_host+':5985/wsman',
                            auth=(remote_username, remote_password),
                            transport='ntlm',
                            server_cert_validation='ignore')
    # 执行命令并打印执行过程
    logging.info(f"Executing command: {command}")
    result = session.run_ps(command)
    logging.info("Command execution completed.")
    # 打印命令执行结果
    logging.info("Command output:")
    logging.info(result.std_out.decode("utf-8"))

nodes = [
## IP Address 		    HostName	        Role
# "10.122.36.100",	#	"SYPQLIKSENSE15"	[PRD] Proxy Engine 04"
# "10.122.36.106",	#	"SYPQLIKSENSE18"	[PRD] Proxy Engine 05"
# "10.122.36.107",	#	"SYPQLIKSENSE11"	[PRD] Proxy Engine 01"
# "10.122.36.108",	#	"SYPQLIKSENSE12"	[PRD] Proxy Engine 02"
# "10.122.36.109",	#	"SYPQLIKSENSE13"	[PRD] Proxy Engine 03"
# "10.122.36.110",	#	"SYPQLIKSENSE14"	[PRD] API 02"
# "10.122.36.119",	#	"SYPQLIKSENSE03"	[PRD] API 01"
# "10.122.36.120",	#	"SYPQLIKSENSE04"	[PRD] Central Master & Scheduler Master"
# "10.122.36.121",	#	"SYPQLIKSENSE05"	[PRD] Scheduler 05"
# "10.122.36.122",	#	"SYPQLIKSENSE06"	[PRD] Central Candidate & Scheduler 01"
# "10.122.36.123",	#	"SYPQLIKSENSE07"	[PRD] Scheduler 02"
# "10.122.36.124",	#	"SYPQLIKSENSE08"	[PRD] Scheduler 03"
# "10.122.36.220",	#	"SYPQLIKSENSE17"	[PRD] Scheduler 04"
# "10.122.36.130",	#	"SYPQLIKSENSE19"	[PRD] SenseNP"
# "10.122.36.111",	#	"PEKWPQLIK05"	    [DEV] Central Master & Scheduler Master"
# "10.122.36.112",	#	"PEKWPQLIK06"	    [DEV] Central Candidate & Scheduler 01"
# "10.122.36.114",	#	"PEKWPQLIK01"	    [DEV] Proxy Engine 01"
# "10.122.36.115",	#	"PEKWPQLIK03"	    [DEV] Proxy Engine 02"
# "10.122.36.116",	#	"PEKWPQLIK04"	    [DEV] Proxy Engine 03"
# "10.122.36.128", 	#	"SYPQLIKSENSE09"	[DEV] Scheduler 02"
# "10.122.27.37",   #   PEKWNQLIK07         [TST]
# "10.122.27.38",   #   PEKWNQLIK08         [TST]
"10.122.27.39",   #   PEKWNQLIK09         [TST]
"10.122.27.1",    #   WIN-G7IG3TRA8E4     [TST]
"10.122.27.3",    #   WIN-ICR6696ONF4     [TST]
"10.122.27.4",    #   SHEWNQLIKRE         [TST]
# "10.122.27.5",    #   WIN-54U2N8LPHD0     [TST]
# "10.122.27.223",   #   "SHEWNQUSC2"        [TST]
]

ps1  = """
$env:COMPUTERNAME
"""

if __name__ == '__main__':
    threads = []
    for node in nodes:
        t = threading.Thread(target=remote_server, args=(node, ps1))
        threads.append(t)
        print("\033[32m {}\033[00m".format(f"{datetime.datetime.now().strftime('[%Y-%m-%d %H:%M:%S]')} The service restart command is issued to {node}" ))
        t.start()
    for t in threads:
        t.join()
'''
Author       : Kui.Chen
Date         : 2023-02-23 17:17:35
LastEditors  : Kui.Chen
LastEditTime : 2023-05-22 10:33:21
FilePath     : \Scripts\Python\Tools\LogScan_QSTaskExecution.py
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import os
import csv
import time
from datetime import datetime, timedelta

app_id = "17e4338c-70f8-48eb-b816-dd9c839a85a6"
export_directory = 'C://Users//douns//Downloads//'

# 格式化时间
suffix      = datetime.now().strftime('%Y%m%d%H%M%S')
export_file = export_directory + 'QsTaskDuration_' + app_id + '_' + suffix +'.csv'

# 创建csv文件
with open(export_file, 'a', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=',', lineterminator='\n')
    # 写入表头
    writer.writerow(['App ID' , 'Total Rows'  , 'Execution Node' , 'Execution Started Time' , 'Execution Finished Time' , 'Interval' , 'Execution Results' , 'Connection Name' ])
    nodes = ["sypqliksense05","sypqliksense06","sypqliksense07","sypqliksense08","sypqliksense17"]
    for node in nodes:
        # scan_directory = "C://Users//douns//Downloads//csv//sypqliksense05"
        scan_directory = '//10.122.84.180/QlikSenseSharedPersistence/ArchivedLogs/'+node+'/Script'
        # 创建筛选范围，以此扫描日志最后修改时间在 days 之内的日志文件
        monthAgo = datetime.now() - timedelta(days=300)
        # 获取文件夹中的所有Log文件
        files = os.listdir(scan_directory)
            # 遍历每个文件
        for file in files:
            # 扫描指定 APP ID
            if app_id in file:
            # 扫描全部 LOG
            # if file.endswith(".log"):
                # 获取文件最后修改时间
                last_modified_time = os.path.getmtime(scan_directory + '/' + file)
                date = datetime.fromtimestamp(last_modified_time)
                # 扫描在最近一个月修改的日志文件
                if date > monthAgo:
                    print ('Checking in ' + file)
                    appid = file.split('.')[0]
                    # 读取带BOM的UTF-8日志文件 encoding 'utf-8-sig'
                    log_file = open(scan_directory + '/' + file, 'r', encoding='utf-8-sig')
                    # 读取日志开始执行时间
                    start_time        = str(log_file.readline().split()[0])
                    date_obj          = datetime.strptime(start_time, '%Y%m%dT%H%M%S.%f%z')
                    execution_started = date_obj.strftime('%Y-%m-%d %H:%M:%S')
                    # 转换日志最后修改日期为执行结束时间
                    execution_finished = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(last_modified_time))
                    # 为导出结果预先赋值
                    data_rows         = []
                    connections       = []
                    execution_results = ""
                    # 遍历检查日志包含信息
                    lines =  log_file.readlines()
                    for line in lines :
                        # 扫描数据连接
                        if 'LIB CONNECT TO' in line:
                            connection_name = line.split('LIB CONNECT TO ')[-1]
                            connections.append(connection_name)
                        # # 增加QVD or Excel数据文件
                        # elif 'FROM [lib:' in line:
                        #     connection_name = (line.split('FROM [lib:')[1]).replace(']', '')
                        #     connections.append(connection_name)
                        # 数据加载行数
                        elif 'lines fetched' in line:
                            data_lines = (line.split(' ')[-3]).replace(',', '')
                            data_line  = int(data_lines)
                            data_rows.append(data_line)
                        # 数据加载结果
                        elif 'successfully' in line or 'Execution Failed' in line: 
                            execution_results = line.split('+0800 ')[1]
                        else:
                            continue
                    # 汇总数据行数
                    total_rows  = sum(data_rows)
                    connections = list(set(connections))
                    # 写入数据到csv文件中
                    writer.writerow([appid, total_rows , node , execution_started , execution_finished, "" , execution_results ,  connections ])
                    # 将每一个 Connection 分列保存
                    # writer.writerow([appid, total_rows , execution_started , execution_finished, "" , execution_results ,  *connections ])
                    # 关闭日志文件
                    log_file.close()
                else:
                    print("指定时间范围内没有日志")
            else:
                continue

print(("-- The log check for {} has completed. --").format(app_id))
csvfile.close()
# 打开下载目录
os.startfile(export_directory)
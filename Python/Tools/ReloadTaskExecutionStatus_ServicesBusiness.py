'''
Author       : Kui.Chen
Date         : 2023-05-29 13:06:24
LastEditors  : Kui.Chen
LastEditTime : 2023-07-13 14:51:20
FilePath     : \Scripts\Python\temp\tmp.py
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import csv
import psycopg2
from datetime import datetime

# 连接到PG SQL数据库
conn = psycopg2.connect(host='10.122.36.117', port=4432, dbname='QSR', user='postgres', password='abcd-1234')
# 创建游标
cur = conn.cursor()
# 定义SQL查询语句
sql_query = """
SELECT 
    B."Name" as "AppName",
    A."AppID", 
    A."TaskID",
    CASE A."Status"
        WHEN 0 THEN 'NeverStarted'
        WHEN 1 THEN 'Triggered'
        WHEN 2 THEN 'Started'
        WHEN 3 THEN 'Queued'
        WHEN 4 THEN 'AbortInitiated'
        WHEN 5 THEN 'Aborting'
        WHEN 6 THEN 'Aborted'
        WHEN 7 THEN 'FinishedSuccess'
        WHEN 8 THEN 'FinishedFail'
        WHEN 9 THEN 'Skipped'
        WHEN 10 THEN 'Retry'
        WHEN 11 THEN 'Error'
        WHEN 12 THEN 'Reset'
        ELSE 'Unknown'
    END as "Status",
    A."StartTime", 
    A."StopTime", 
    A."Duration"/ (1000 * 60) as "Duration (minutes)", 
    A."ExecutingNodeName", 
    U."Name" as "OwnerName",
    S."Name" as "StreamName"
FROM 
    "ExecutionResults" A
JOIN 
    "Apps" B ON A."AppID" = B."ID"
JOIN 
    "Streams" S ON B."Stream_ID" = S."ID"
JOIN 
    "Users" U ON B."Owner_ID" = U."ID"
WHERE
    S."Name" = 'Services Business'
"""
# 执行SQL查询
cur.execute(sql_query)
# 获取查询结果
results = cur.fetchall()
# 生成带时间戳的文件名
timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
# 导出结果到CSV文件
csv_file = r"\\pekwpqlik06\Sharing_Data\service_upsell\ServicesBusinessAppsDataReloadTaskExecutionStatus_{}.csv".format(timestamp)

with open(csv_file, "w", newline="") as file:
    writer = csv.writer(file)
    # 写入表头
    writer.writerow([desc[0] for desc in cur.description])
    # 写入数据行
    writer.writerows(results)
# 关闭游标和数据库连接
cur.close()
conn.close()
print("Done.")
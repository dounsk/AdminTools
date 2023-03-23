import os
import csv
import datetime
import psycopg2

def taskStatus():
    conn = psycopg2.connect(host='10.122.36.117', port=4432, dbname='QSR', user='postgres', password='abcd-1234')
    cur = conn.cursor()
    sql = """
    SELECT 
        TO_CHAR(current_timestamp, 'yyyy-MM-dd HH24:MI:SS') AS "DateTime", 
        COUNT(CASE WHEN "Status" = '2' THEN 1 END) AS "Started_Number", 
        COUNT(CASE WHEN "Status" = '3' THEN 1 END) AS "Queued_Number", 
        "ExecutingNodeName" 
    FROM 
        "ExecutionResults" 
    GROUP BY 
        "ExecutingNodeName";
    """
    cur.execute(sql)
    results = cur.fetchall()
    # print("DateTime\tStarted\tQueued\tExecutingNode")
    data = {}
    for result in results:
        if result[1] > 1:
            data['DateTime'] = result[0]
            data['Started_Number'] = result[1]
            data['Queued_Number'] = result[2]
            data['ExecutingNodeName'] = result[3]
            writer.writerow(data)
    cur.close()
    conn.close()

if __name__ == '__main__':
    export_directory = "//10.122.36.118//QlikOperations//QsTaskStatus//"
    fieldnames = ['DateTime', 'Started_Number', 'Queued_Number', 'ExecutingNodeName']
    suffix      = datetime.datetime.now().strftime('%Y%m%d')
    export_file = export_directory + 'QlikSense_TaskStatus_' + suffix +'.csv'
    # 判断文件是否存在，如果存在则读取表头
    if os.path.isfile(export_file):
        with open(export_file, 'r') as f:
            reader = csv.reader(f)
            headers = next(reader)
            if headers == fieldnames:
                add_header = False
            else:
                add_header = True
        f.close()
    else:
        add_header = True
    # 写入数据
    with open(export_file, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames)
        if add_header:
            writer.writeheader()
        taskStatus()
    f.close()
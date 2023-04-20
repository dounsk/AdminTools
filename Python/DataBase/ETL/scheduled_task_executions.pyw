import psycopg2
import pymysql
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

if __name__ == '__main__':
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
    for result in results:
        if result[1] > 1:
            Started_Number = result[1]
            Queued_Number = result[2]
            ExecutingNodeName = result[3]
            insertinto = 'INSERT INTO scheduled_task_executions (id, DATETIME, ExecutingNode, Started, Queued) '
            insertinto += f"VALUES (null, NOW(), '{ExecutingNodeName}', '{Started_Number}', '{Queued_Number}');"
            # 插入到Mysql
            implement(insertinto)
    cur.close()
    conn.close()

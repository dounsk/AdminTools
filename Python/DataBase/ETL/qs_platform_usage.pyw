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
          COUNT(CASE WHEN table_name = 'Users'  THEN "ID" END) AS users_total,
          COUNT(CASE WHEN table_name = 'Users' AND "UserDirectory" = 'LENOVOAD' THEN "ID" END) AS users_lenovoad,
          COUNT(CASE WHEN table_name = 'Streams' THEN "ID" END) AS streams_count,
          COUNT(CASE WHEN table_name = 'Apps' THEN "ID" END) AS apps_count,
          COUNT(CASE WHEN table_name = 'ReloadTasks' THEN "ID" END) AS reload_tasks_count
        FROM (
          SELECT 'Users' AS table_name, "ID", "UserDirectory" FROM "Users"
          UNION ALL
          SELECT 'Streams' AS table_name, "ID", NULL FROM "Streams"
          UNION ALL
          SELECT 'Apps' AS table_name, "ID", NULL FROM "Apps"
          UNION ALL
          SELECT 'ReloadTasks' AS table_name, "ID", NULL FROM "ReloadTasks"
        ) subquery;
    """
    cur.execute(sql)
    results = cur.fetchall()
    for result in results:
        if result[1] > 1:
            users_total = result[0]
            users_lenovoad = result[1]
            stream = result[2]
            apps = result[3]
            tasks = result[4]
            insertinto = 'INSERT INTO qs_platform_usage (date, users_total, users_lenovoad, streams_count, apps_count, reload_tasks_count) '
            insertinto += f"VALUES (CURDATE(), '{users_total}', '{users_lenovoad}', '{stream}', '{apps}', '{tasks}');"
            # 插入到Mysql
            implement(insertinto)
    cur.close()
    conn.close()

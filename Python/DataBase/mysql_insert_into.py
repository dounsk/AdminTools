'''
Author       : Kui.Chen
Date         : 2023-04-14 16:59:43
LastEditors  : Kui.Chen
LastEditTime : 2023-04-19 10:43:32
FilePath     : \Scripts\Python\DataBase\mysql_insert_into.py
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import psycopg2
import pymysql
import configparser

def connect():
    '''连接MySQL数据库'''
    try:
        config = configparser.ConfigParser()
        config.read('Python\DataBase\config.ini')
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
    SELECT COUNT("ID") FROM "Users";
    SELECT COUNT("ID") FROM "Users" WHERE "UserDirectory" = 'LENOVOAD';
    SELECT COUNT("ID") FROM "Streams";
    SELECT COUNT("ID") FROM "Apps";
    SELECT COUNT("ID") FROM "ReloadTasks";

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
            insertinto = 'INSERT INTO qs_platform_usage (id, DATE, users_total, users_lenovoad, stream, apps, tasks) '
            insertinto += f"VALUES (null, NOW(), '{users_total}', '{users_lenovoad}', '{stream}', '{apps}', '{tasks}');"
            # 插入到Mysql
            print(insertinto)
            # implement(insertinto)
    cur.close()
    conn.close()
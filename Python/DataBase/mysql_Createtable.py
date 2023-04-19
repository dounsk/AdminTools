'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-04-19 15:38:34
FilePath     : \Scripts\Python\DataBase\mysql_Createtable.py
Description  : update to mysql
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import pymysql
import configparser

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

sql  = """

# 建表语句：
# CREATE TABLE IF NOT EXISTS `qs_platform_usage`(
#    `id` INT UNSIGNED AUTO_INCREMENT,
#    `date` DATE,
#     `users_total`  DECIMAL(10,0),
#    `users_lenovoad`  DECIMAL(10,0),
#    `streams_count`  DECIMAL(10,0),
#    `apps_count`  DECIMAL(10,0),
#    `reload_tasks_count`  DECIMAL(10,0),
#    PRIMARY KEY ( `id` )
# )ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 查询表结构：
# desc qs_platform_usage;

# 查询
# SELECT * FROM scheduled_task_executions limit 100;

# 删除表：
# DROP TABLE `qs_platform_usage` ;

# 检查用户权限
# SHOW GRANTS FOR 'data_collector'@'%';

# GRANT SELECT, INSERT, UPDATE ON qliksense.* TO 'data_collector'@'%';
# flush privileges;

# INSERT INTO qs_platform_usage ( date, users_total, users_lenovoad, streams_count, apps_count, reload_tasks_count) VALUES ( CURDATE(), '23814', '19311', '330', '3352', '3969');

"""

if __name__ == '__main__':
    implement(sql)
'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-04-17 09:55:21
FilePath     : \Scripts\Python\temp\test.py
Description  : update to mysql
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

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

sql  = """

# CREATE TABLE IF NOT EXISTS `scheduled_task_executions`(
#    `id` INT UNSIGNED AUTO_INCREMENT,
#    `DateTime` DATETIME,
#    `ExecutingNode` VARCHAR(20) NOT NULL,
#    `Started`  DECIMAL(10,0),
#    `Queued`  DECIMAL(10,0),
#    PRIMARY KEY ( `id` )
# )ENGINE=InnoDB DEFAULT CHARSET=utf8;

# desc scheduled_task_executions;

# selete * form scheduled_task_executions;

-- 创建用于数据采集的用户
CREATE USER 'data_collector'@% IDENTIFIED BY 'GetData#4Anywhere';
# -- 授予该用户读取和写入数据库的权限
# GRANT SELECT, INSERT, UPDATE ON database_name.* TO 'data_collector'@'localhost';
# -- 禁止该用户删除表的权限
# REVOKE DROP ON database_name.* FROM 'data_collector'@'localhost';

"""

if __name__ == '__main__':
    implement(sql)
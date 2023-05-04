'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-04-25 15:12:43
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


# CREATE TABLE scheduled_task_executions_dev (
#   `id` int(11) NOT NULL AUTO_INCREMENT,
#   `datetime` DATETIME NOT NULL,
#   `ExecutingNode` VARCHAR(20) NOT NULL,
#   `Started` DECIMAL(10,0),
#   `Queued` DECIMAL(10,0),
#   PRIMARY KEY (id)
# );

# CREATE TABLE api_monitoring_logs (
#   `id` int(11) NOT NULL AUTO_INCREMENT,
#   `log_time` datetime NOT NULL,
#   `environment` varchar(100) NOT NULL,
#   `node_role` varchar(100) NOT NULL,
#   `ip_address` varchar(100) NOT NULL,
#   `service_name` varchar(100) NOT NULL,
#   PRIMARY KEY (id)
# );

# CREATE TABLE `win_event_logs` (
#   `id` int(11) NOT NULL AUTO_INCREMENT,
#   `Time` varchar(50) NOT NULL,
#   `service_name` varchar(50) NOT NULL,
#   `status` varchar(50) NOT NULL,
#   `update_time` datetime NOT NULL,
#   PRIMARY KEY (`id`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# CREATE TABLE `win_event_logs` (
#   Time DATETIME NOT NULL,
#   EntryType VARCHAR(50) NOT NULL,
#   Source VARCHAR(50) NOT NULL,
#   InstanceID VARCHAR(10) NOT NULL,
#   Message TEXT NOT NULL,
#   Hostname VARCHAR(50) NOT NULL
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# INSERT INTO win_event_logs (Time, EntryType, Source, InstanceID, Message, Hostname) VALUES ('04/25/2023 14:39:41', 'Error', 'Engine', '300', 'The description for Event ID '300' in Source 'Engine' cannot be found.  The local computer may not have the necessary registry information or message DLL files to display the message, or you may not have permission to access them.  The following information is part of the event:'ServerDocumentEntry: DoLoad caught exception -129'', 'SYPQLIKSENSE18.lenovo.com')

# 查询表结构：
# desc qs_platform_usage;

# 查询
# SELECT * FROM scheduled_task_executions limit 100;

# 删除表：
# DROP TABLE `test` ;

# 检查用户权限
# SHOW GRANTS FOR 'data_collector'@'%';

# GRANT SELECT, INSERT, UPDATE ON qliksense.* TO 'data_collector'@'%';
# flush privileges;

# INSERT INTO qs_platform_usage ( date, users_total, users_lenovoad, streams_count, apps_count, reload_tasks_count) VALUES ( CURDATE(), '23814', '19311', '330', '3352', '3969');

INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikLoggingService', 0, NOW());
INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikSenseEngineService', 2, NOW());
INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikSensePrintingService', 0, NOW());
INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikSenseProxyService', 2, NOW());
INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikSenseRepositoryService', 2, NOW());
INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikSenseSchedulerService', 0, NOW());
INSERT INTO qs_service_status (machine_name, service_name, status, update_time) VALUES ('SYPQLIKSENSE15', 'QlikSenseServiceDispatcher', 2, NOW());

"""

if __name__ == '__main__':
    implement(sql)
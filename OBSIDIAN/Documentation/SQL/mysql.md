
数据库备份：

```cmd
mysqldump -u root -p qliksense > "D:\BaseofTom&Jerry\db_backup\mysql_qliksense_backup_10.122.36.184_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql"

mysqldump -u root -p datapeak > "D:\BaseofTom&Jerry\db_backup\mysql_datapeak_backup_10.122.36.184_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql"

```

用户权限：
```mysql
-- 创建用户
CREATE USER 'data_collector'@'localhost' IDENTIFIED BY 'GetData4Anywhere';

update user set host = '%' where user = 'data_collector';

-- 刷新权限
flush privileges;
-- 授权
GRANT SELECT, INSERT, UPDATE ON qliksense.* TO 'data_collector'@'%';
-- 禁止该用户删除表的权限
REVOKE DROP ON qliksense.* FROM 'data_collector'@'%';
-- 删除表
DROP TABLE `qs_platform_usage` ;
```

建表语句：
```mysql
CREATE TABLE IF NOT EXISTS `qs_platform_usage`(
	`id` INT UNSIGNED AUTO_INCREMENT,
	`datetime` DATETIME,
	`users_total`  DECIMAL(10,0),
	`users_lenovoad`  DECIMAL(10,0),
	`streams_count`  DECIMAL(10,0),
	`apps_count`  DECIMAL(10,0),
	`reload_tasks_count`  DECIMAL(10,0),
	PRIMARY KEY ( `id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE scheduled_task_executions_dev (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` DATETIME NOT NULL,
  `ExecutingNode` VARCHAR(20) NOT NULL,
  `Started` DECIMAL(10,0),
  `Queued` DECIMAL(10,0),
  PRIMARY KEY (id)
);

```

数据插入：
```mysql
INSERT INTO qs_platform_usage ( 
date, users_total, users_lenovoad, streams_count, apps_count, reload_tasks_count
) 
VALUES ( 
CURDATE(), '23814', '19311', '330', '3352', '3969'
);

```

删除数据行
```mysql
DELETE FROM `qliksense`.`qs_service_status`
WHERE `id` in (214, 215,216,217 );

SELECT *
FROM `qliksense`.`qs_service_status`;
```
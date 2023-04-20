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
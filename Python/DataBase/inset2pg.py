#  -*- coding: utf-8 -*-
import datetime
import uuid
import psycopg2


id = str(uuid.uuid4())
date = datetime.datetime.now().strftime("'"+'%Y-%m-%d %H:%M:%S'+"'")+' , '

## 连接到数据库
conn = psycopg2.connect(database="postgres", user="qlik",password="Aa12345678", host="10.122.36.129", port="5432")
## 建立游标，用来执行数据库操作
cursor = conn.cursor()
##设置目标表
table = 'Test11'
## 执行SQL命令
cursor.execute("CREATE TABLE if not exists "+table+"( \
                        UUID varchar(255) PRIMARY KEY     NOT NULL, \
                        Date TIMESTAMP NOT NULL, \
                        City varchar(255) , \
                        CityID varchar(20)  \
                        )")

insert_sql = "INSERT INTO "+table+" \
                    values('"+id+"',"+date+"'北京' , 'beijing') \
                    on conflict on constraint "+table+"_pkey\
                    do nothing;"

cursor.execute(insert_sql)
 
## 提交SQL命令
conn.commit()
 
## 执行SQL SELECT命令
cursor.execute("select * from "+table+"")
 
## 获取SELECT返回的元组
rows = cursor.fetchall() #获取全部数据
# rows = cursor.fetchmany(size=500) #batch为500条数据进行获取
for row in rows:
    print(row)
 
## 关闭游标
cursor.close()
 
## 关闭数据库连接
conn.close()
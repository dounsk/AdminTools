#  -*- coding: utf-8 -*-
import psycopg2

conn = psycopg2.connect(database="NPrinting", user="qlik",password="Aa12345678", host="10.122.36.129", port="5432")
cursor = conn.cursor()

schemaname = "'public'"

cursor.execute("select tablename from pg_tables where schemaname="+schemaname+";")

rows = cursor.fetchall() #获取全部数据
# rows = cursor.fetchmany(size=100) #batch为100条数据进行获取

for i in rows:
    row = str(i).replace('(', '').replace(')', '').replace(',', '').replace("'", '')
    print(row)
    
cursor.close()
conn.close()
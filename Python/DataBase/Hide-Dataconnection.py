#  -*- coding: utf-8 -*-
import uuid
import psycopg2

uuid = str(uuid.uuid4())

conn = psycopg2.connect(database="NPrinting", user="qlik",password="Aa12345678", host="10.122.36.129", port="5432")
cursor = conn.cursor()
##设置目标表
table = 'public."DataConnections"'

cursor.execute("select "+'"'+"ID"+'"'+" from "+table+";")

rows = cursor.fetchall() #获取全部数据
# rows = cursor.fetchmany(size=100) #batch为100条数据进行获取

for i in rows:
    row = str(i).replace('(', '').replace(')', '').replace(',', '')
    # print(row)
    update_sql = "UPDATE "+table+" \
                        SET "+'"'+"Name"+'" = '+row+', "'+"Connectionstring"+'" = '+row+',"'+"Username"+'" = '+row+', "'+"PasswordString"+'" = '+row+'  \
                        WHERE '+'"'+"ID"+'" ='+row+";"
    print(update_sql)
    cursor.execute(update_sql)
    conn.commit()
    
    # cursor.execute("select * from "+table+"  \
    #             WHERE "+'"'+"ID"+'" ='+row+";")
    # select_sql = cursor.fetchall()
    # print(select_sql)

cursor.close()
conn.close()

print("--- Update execution complete! ---")
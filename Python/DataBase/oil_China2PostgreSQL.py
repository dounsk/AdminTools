#  -*- coding: utf-8 -*-
import datetime
import bs4
import time
import requests
import psycopg2
import uuid

conn = psycopg2.connect(database="postgres", user="qlik",password="Aa12345678", host="10.122.36.129", port="5432")

cursor = conn.cursor()
cursor.execute("""CREATE TABLE if not exists Oil_China(
                        UUID varchar(255) PRIMARY KEY     NOT NULL,
                        Date date NOT NULL, 
                        Time time NOT NULL,
                        City varchar(255) ,
                        CityID varchar(20) ,
                        Type_92 text ,
                        oil_92 numeric(10,2) ,
                        Type_95 text ,
                        oil_95 numeric(10,2) ,
                        Type_98 text ,
                        oil_98 numeric(10,2) ,
                        Type_0 text ,
                        oil_0 numeric(10,2) 
                        )""")
for i in [
            f'https://oil.usd-cny.com/anhui.htm', #安徽
            f'https://oil.usd-cny.com/beijing.htm', #北京
            f'https://oil.usd-cny.com/chongqing.htm', #重庆
            f'https://oil.usd-cny.com/fujian.htm', #福建
            f'https://oil.usd-cny.com/gansu.htm', #甘肃
            f'https://oil.usd-cny.com/guangdong.htm', #广东
            f'https://oil.usd-cny.com/guangxi.htm', #广西
            f'https://oil.usd-cny.com/guizhou.htm', #贵州
            f'https://oil.usd-cny.com/hainan.htm', #海南
            f'https://oil.usd-cny.com/hebei.htm', #河北
            f'https://oil.usd-cny.com/heilongjiang.htm', #黑龙江
            f'https://oil.usd-cny.com/henan.htm', #河南
            f'https://oil.usd-cny.com/hubei.htm', #湖北
            f'https://oil.usd-cny.com/hunan.htm', #湖南
            f'https://oil.usd-cny.com/jiangsu.htm', #江苏
            f'https://oil.usd-cny.com/jiangxi.htm', #江西
            f'https://oil.usd-cny.com/jilin.htm', #吉林
            f'https://oil.usd-cny.com/liaoning.htm', #辽宁
            f'https://oil.usd-cny.com/neimenggu.htm', #内蒙古
            f'https://oil.usd-cny.com/ningxia.htm', #宁夏
            f'https://oil.usd-cny.com/qinghai.htm', #青海
            f'https://oil.usd-cny.com/shaanxi.htm', #陕西
            f'https://oil.usd-cny.com/shandong.htm', #山东
            f'https://oil.usd-cny.com/shanghai.htm', #上海
            f'https://oil.usd-cny.com/shanxi.htm', #山西
            f'https://oil.usd-cny.com/shenzhen.htm', #深圳
            f'https://oil.usd-cny.com/sichuan.htm', #四川
            f'https://oil.usd-cny.com/tianjin.htm', #天津
            f'https://oil.usd-cny.com/xinjiang.htm', #新疆
            f'https://oil.usd-cny.com/xizang.htm', #西藏
            f'https://oil.usd-cny.com/yunnan.htm', #云南
            f'https://oil.usd-cny.com/zhejiang.htm', #浙江
        ]:

 
    resp = requests.get(url=i,headers={'User-Agent': 'BaiduSpider'})
    resp.encoding='GB2312'
    soup = bs4.BeautifulSoup(resp.text, 'lxml')
    city = str("'"+soup.h1.text+"' , ")
    cityid = i.replace('https://oil.usd-cny.com/', "'").replace('.htm', "' , ")
    info = str(soup.find_all('td')).replace('<td>', "'").replace('</td>', "'").replace('[', '').replace(']', '').replace(',', ' , ')
    print(info)
    id = str(uuid.uuid4())
    date = datetime.datetime.now().strftime("'"+'%Y-%m-%d'+"'")+' , '
    time = datetime.datetime.now().strftime("'"+'%H:%M:%S'+"'")+' , '
    insert_sql = "INSERT INTO Oil_China \
                    values('"+id+"' , "+date+time+city+cityid+info+") \
                    on conflict on constraint Oil_China_pkey\
                    do nothing;"
    cursor.execute(insert_sql)
    conn.commit()

## 执行SQL SELECT命令
cursor.execute("select * from Oil_China")
 
## 获取SELECT返回的元组
rows = cursor.fetchall() #获取全部数据
# rows = cursor.fetchmany(size=500) #batch为500条数据进行获取
for row in rows:
    print(row)
    
cursor.close()
conn.close()
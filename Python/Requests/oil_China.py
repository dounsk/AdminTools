#  -*- coding: utf-8 -*-
import datetime
import bs4
import time
import requests

path = "./Data/oil_China.txt"
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

    with open(path,"a", encoding='utf-8') as f:
        resp = requests.get(url=i,headers={'User-Agent': 'BaiduSpider'})
        resp.encoding='GB2312'
        soup = bs4.BeautifulSoup(resp.text, 'lxml')
        city = soup.h1.text+' , '
        cityid = i.replace('https://oil.usd-cny.com/', '').replace('.htm', ' , ')
        info = str(soup.find_all('td')).replace('<td>', '').replace('</td>', '').replace('[', '').replace(']', '').replace(',', ' , ')
        date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')+' , '
        print(date+city+cityid+info)
        f.writelines(date+city+info)
        f.writelines("\n")
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-10-20 11:04:16
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$

import requests
import bs4
import re
import datetime

resp = requests.get(url=f'https://oil.usd-cny.com/tiaozheng/',headers={'User-Agent': 'BaiduSpider'})
resp.encoding='GB2312'
soup = bs4.BeautifulSoup(resp.text, 'lxml')
header = str(soup.find('p')).replace('<p class="time">', '').replace('</p>', '')
# print (header)
# info = str(soup.find('table')).replace('上涨', '+').replace('下调', '-')
info = soup.find_all('td')
for i,x in enumerate(info):
    print(x)
    if i == 5:

        # 获取油价调整日期
        tiaozheng = str(x).replace('<td>', '').replace('</td>', '')

today = datetime.datetime.now().strftime('%Y-%m-%d')
if tiaozheng == today:
    print("今日油价调整了！")
else:
    print("今日油价维持不变。")

import re
import bs4
import requests

f = open("oil_adjust.html",'w', encoding='utf-8')

resp = requests.get(url=f'https://oil.usd-cny.com/tiaozheng/',headers={'User-Agent': 'BaiduSpider'})
resp.encoding='GB2312'
soup = bs4.BeautifulSoup(resp.text, 'lxml')
header = str(soup.find('p')).replace('<p class="time">', '').replace('</p>', '')
# print (header)
# info = str(soup.find('table')).replace('上涨', '+').replace('下调', '-')
info = soup.find('table')
# print (info)
f.write(str(info))
f.close()
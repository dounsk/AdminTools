import datetime
import os
import bs4
import requests

path = "D:\py\Data\get"
filename = "\oil_Beijing.txt"
 
with open(path+filename,"a",encoding='GB2312') as f:
    resp = requests.get(url=f'https://oil.usd-cny.com/beijing.htm',headers={'User-Agent': 'BaiduSpider'})
    resp.encoding='GB2312'
    soup = bs4.BeautifulSoup(resp.text, 'lxml')
    city = soup.h1.text+' , '
    info = str(soup.find_all('td')).replace('<td>', '').replace('</td>', '').replace('[', '').replace(']', '').replace(',', ' , ')
    date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')+' , '
    print (date+city+info)
    f.writelines(date+city+info)
    f.writelines("\n")

#open path in windows explorer 
os.system("explorer.exe %s" % path)
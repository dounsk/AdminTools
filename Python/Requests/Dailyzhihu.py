import datetime
import json
import requests as re
import sys

# 获取知乎日报列表
header = {
    'user-agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36'}
r = re.get('https://news-at.zhihu.com/api/4/news/latest',
            headers=header)  
rjson = json.loads(r.text)
if not rjson:
    sys.exit()

for i in rjson['stories']:
    title = i['title']
    url = i['url']
    date = i['ga_prefix'][:4]
    print(date, title, url)
    # Subject = 'News '+date+' - '+title
    
    # 获取日报内容
    # resp = requests.get(url,
    #                 headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.101 Safari/537.36'})
    # resp.encoding='utf-8'
    # soup = bs4.BeautifulSoup(resp.text, 'lxml')
    # MailContent = soup.find(class_ = 'content')
    # print (Subject)
    # print (MailContent)

'''
Author: Kui.Chen
Date: 2022-10-19 10:28:21
LastEditors: Kui.Chen
LastEditTime: 2023-02-28 11:23:03
FilePath: \Scripts\Python\SMTP\m_dailyzhihu.py
Description: 
Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import bs4
import json
import smtplib
import requests
import time
import random
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Mail 设置
mail_set = {
    "host": "Smtpinternal.lenovo.com",
    "pwd": 'CgFU-2202',
    "sender": "qlikplatform@lenovo.com",
    "receivers": [
                  'kuichen1@lenovo.com',
                 ],}

class SendMail(object):
    @staticmethod
    def get_message():
        message = MIMEMultipart()
        message['From'] = mail_set['sender']
        message['To'] = ';'.join(mail_set['receivers'])
        message['Subject'] = Subject
        return message

    def get_content(self):
        message = self.get_message()
        content = MIMEText(MailContent, 'html', 'utf-8')
        message.attach(content)
        return message

    @staticmethod
    def send(message, receivers):
        try:
            smtp_obj = smtplib.SMTP(mail_set['host'])
            smtp_obj.connect(mail_set['host'], 25)
            smtp_obj.ehlo()
            smtp_obj.starttls()
            smtp_obj.login(mail_set['sender'], mail_set['pwd'])

            smtp_obj.sendmail(mail_set['sender'],
                              receivers,
                              message.as_string())
            print('Successfully!')
        except smtplib.SMTPException as e:
            print('Failed,Error:{}'.format(e))

    def run(self):
        user_message = self.get_content()
        user_receivers = mail_set['receivers']
        self.send(user_message, user_receivers)

# 获取知乎日报列表
header = {
    'user-agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36'}
r = requests.get('https://news-at.zhihu.com/api/4/news/latest',
            headers=header)  
rjson = json.loads(r.text)
# if not rjson:
#     sys.exit()

for i in rjson['stories']:
    title = i['title']
    url = i['url']
    date = i['ga_prefix'][:4]
    Subject = 'News '+date+' - '+title
    # 获取日报内容
    resp = requests.get(url,
                    headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.101 Safari/537.36'})
    resp.encoding='utf-8'
    soup = bs4.BeautifulSoup(resp.text, 'lxml')
    MailContent = soup.find(class_ = 'content')
    # 发送邮件
    app = SendMail()
    app.run()
    #小憩片刻😊
    time.sleep(random.random() * 4 + 1)
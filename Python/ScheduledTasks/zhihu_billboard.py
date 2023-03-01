#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2023-01-11 16:51:43
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$

import bs4
import smtplib
import requests
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


resp = requests.get(url=f'https://www.zhihu.com/billboard',
    headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36'}
)
soup = bs4.BeautifulSoup(resp.text, 'lxml')
links = str(soup.find_all('a')).replace('[', '').replace(']', '').replace(',', '')

mail_set = {
    "host": "smtp.office365.com",
    "pwd": 'KFCrazy4V50ToMe',
    "sender": "noreply@8088.onmicrosoft.com",
    "receivers": [
                  'dounsk@outlook.com',
                 ],
    "Subject":"知乎热榜 - 知乎",
    "Content":links,
}

class SendMail(object):

    @staticmethod
    def get_message():
        message = MIMEMultipart()
        message['From'] = mail_set['sender']
        message['To'] = ';'.join(mail_set['receivers'])
        message['Subject'] = mail_set['Subject']
        return message

    def get_content(self):
        message = self.get_message()
        content = MIMEText(mail_set['Content'], 'html', 'utf-8')
        message.attach(content)
        return message

    @staticmethod
    def send(message, receivers):
        try:
            smtp_obj = smtplib.SMTP(mail_set['host'])
            smtp_obj.connect(mail_set['host'], 587)
            smtp_obj.ehlo()
            smtp_obj.starttls()
            smtp_obj.login(mail_set['sender'], mail_set['pwd'])

            smtp_obj.sendmail(mail_set['sender'],
                              receivers,
                              message.as_string())
            print('The notification email was sent successfully!')
        except smtplib.SMTPException as e:
            print('Notification email failed to be sent，Error：{}'.format(e))

    def run(self):
        user_message = self.get_content()
        user_receivers = mail_set['receivers']
        self.send(user_message, user_receivers)

app = SendMail()
app.run()
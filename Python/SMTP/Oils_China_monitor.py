#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-10-19 17:38:49
# @Author  : kui (🌻)
# @Link    : 🖐

import re
import os
import bs4
import smtplib
import datetime
import requests
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication

def sendmail(smtp_host,smtp_port,subject,smtp_sender,smtp_receive,password):

    message = MIMEMultipart()
    message['Subject'] = subject
    message['From'] = smtp_sender
    message['To'] = smtp_receive

    message.attach(MIMEText(mailtxt, 'plain', 'utf-8'))

    attimag = MIMEImage(open(image,"rb").read())
    attimag.add_header('Content-Disposition', 'attachment', filename = attachmentname)
    message.attach(attimag)

    smtp = smtplib.SMTP(smtp_host, smtp_port)
    smtp.connect(smtp_host, smtp_port)
    smtp.ehlo()
    smtp.starttls()
    smtp.login(smtp_sender, password)
    smtp.sendmail(smtp_sender, smtp_receive, message.as_string())
    print('Sent successfully!')
    smtp.quit()

if __name__ == '__main__':
	smtp_host = "Smtpinternal.lenovo.com"
	smtp_port = "25"
	subject = "Oil prices Today in China-Beijing"
	smtp_sender = "qlikplatform@lenovo.com"
	smtp_receive = "kuichen1@lenovo.com"
	password = 'CgFU-2202'

resp = requests.get(url=f'https://oil.usd-cny.com/tiaozheng/',headers={'User-Agent': 'BaiduSpider'})
resp.encoding='GB2312'
soup = bs4.BeautifulSoup(resp.text, 'lxml')
header = str(soup.find('p')).replace('<p class="time">', '').replace('</p>', '')
# print (header)
# info = str(soup.find('table')).replace('上涨', '+').replace('下调', '-')
info = soup.find_all('td')
for i,x in enumerate(info):
    if i == 5:
        # 获取油价调整日期
        tiaozheng = str(x).replace('<td>', '').replace('</td>', '')

today = datetime.datetime.now().strftime('%Y-%m-%d')
if tiaozheng == today:
	image = "//10.122.36.112/Sharing_Data/CSV_kui/Data/Oils/Oils_China_"+datetime.datetime.now().strftime('%Y%m%d')+".png"
	attachmentname = "Oils_China_Today.PNG"
	mailtxt = "今日油价调整了！请查看附件."
	sendmail(smtp_host,smtp_port,subject,smtp_sender,smtp_receive,password)
else:
	print("检查今日油价维持不变。")
	# image = "//10.122.36.112/Sharing_Data/CSV_kui/Data/Oils/Oils_China_"+datetime.datetime.now().strftime('%Y%m%d')+".png"
	# attachmentname = "Oils_China_Today.PNG"
	# mailtxt = "今日油价维持不变,但是为了测试给您提供一个最新的油价趋势图，哈哈。"
	# sendmail(smtp_host,smtp_port,subject,smtp_sender,smtp_receive,password)
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-10-19 17:38:49
# @Author  : kui (🌻)
# @Link    : 🖐


import os
import smtplib
import datetime
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication

mailtxt = "请查看附件"

def sendmail(smtp_host,smtp_port,subject,smtp_sender,smtp_receive,password):

    message = MIMEMultipart()
    message['Subject'] = subject
    message['From'] = smtp_sender
    message['To'] = smtp_receive

    message.attach(MIMEText(mailtxt, 'plain', 'utf-8'))

    attimag = MIMEImage(open("D:/py/Data/Oils_China_20221019.png","rb").read())
    attimag.add_header('Content-Disposition', 'attachment', filename="testatt.jpg")
    message.attach(attimag)

    smtp = smtplib.SMTP(smtp_host, smtp_port)
    smtp.connect(smtp_host, smtp_port)
    smtp.ehlo()
    smtp.starttls()
    smtp.login(smtp_sender, password)
    smtp.sendmail(smtp_sender, smtp_receive, message.as_string())
    print('发送成功')
    smtp.quit()

if __name__ == '__main__':
    smtp_host = "Smtpinternal.lenovo.com"
    smtp_port = "25"
    subject = "Testmail"
    smtp_sender = "qlikplatform@lenovo.com"
    smtp_receive = "kuichen1@lenovo.com"
    password = 'CgFU-2202'
    sendmail(smtp_host,smtp_port,subject,smtp_sender,smtp_receive,password)




#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-12-02

import os
import smtplib
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

with open("//10.122.36.118/QlikOperations/WARNING/ServerMemoryUsage.log", 'r', encoding='utf-16') as file:
    message = file.read()
    txt = message.split('\n')

mail_set = {
    "host": "Smtpinternal.lenovo.com",
    "pwd": 'CgFU-2202',
    "sender": "qlikplatform@lenovo.com",
    "receivers": [
                  'qlikplatform@lenovo.com', 
                  'Maxx1@lenovo.com', 
                  'kuichen1@lenovo.com', 
                  'zhangzh42@lenovo.com'
                 ],
    "Subject":txt[0],        
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
        content = MIMEText(
            txt[1] + '\r\n' +
            txt[2] + txt[3] )
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
            print('Failed，Error：{}'.format(e))

    def run(self):
        user_message = self.get_content()
        user_receivers = mail_set['receivers']
        self.send(user_message, user_receivers)

#run
app = SendMail()
app.run()

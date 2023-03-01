'''
Author: Kui.Chen
Date: 2022-11-10 10:43:30
LastEditors: Kui.Chen
LastEditTime: 2023-02-28 11:22:31
FilePath: \Scripts\Python\SMTP\SMTP_Office365.py
Description: 
Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-11-10 10:42:21
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$


import os
import smtplib
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


mail_set = {
    "host": "smtp.office365.com",
    "pwd": 'KFCrazy4V50ToMe',
    "sender": "noreply@8088.onmicrosoft.com",
    "receivers": [
                  'kuichen1@lenovo.com',
                  'dounsk@outlook.com',
                 ],
    "Subject":"mailsTest",
	"Content":"Hello!",
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
            print('Successfully!')
        except smtplib.SMTPException as e:
            print('Failed, Error:{}'.format(e))

    def run(self):
        user_message = self.get_content()
        user_receivers = mail_set['receivers']
        self.send(user_message, user_receivers)

#run
app = SendMail()
app.run()
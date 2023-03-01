'''
Author: Kui.Chen
Date: 2022-11-17 12:10:53
LastEditors: Kui.Chen
LastEditTime: 2023-02-28 11:21:31
FilePath: \Scripts\Python\SMTP\Notification.pyw
Description: 
Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import os
import time
import smtplib
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


filename = os.getenv("TEMP")+"\\tmp.txt"
with open(filename, 'r', encoding='utf-16') as file_object:
	tmpinfo = file_object.read()

mail_set = {
    "host": "smtp.office365.com",
    "pwd": 'KFCrazy4V50ToMe',
    "sender": "noreply@8088.onmicrosoft.com",
    "receivers": [
                  'dounsk@outlook.com',
                 ],
    "Subject":"The administrator is inactive",
	"Content":('Dear,' + '<br>' +
		'We have no monitored of administrator activity...' + '<br>' +
		tmpinfo ),
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
            print('Notification email failed to be sent, Error:{}'.format(e))

    def run(self):
        user_message = self.get_content()
        user_receivers = mail_set['receivers']
        self.send(user_message, user_receivers)

app = SendMail()
app.run()

time.sleep(3)
os.path.exists(filename)
os.remove(filename)
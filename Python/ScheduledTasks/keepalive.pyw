#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-11-15 17:26:37
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$

import os
import uuid
import random
import smtplib
import datetime
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

path = "//10.122.36.118/Sharing_Data/Share_Folder/"
BEGIN = "-----BEGIN RSA PRIVATE KEY-----" + "\n"
END = "-----END RSA PRIVATE KEY-----" + "\n"

mail_set = {
    "host": "smtp.office365.com",
    "pwd": 'KFCrazy4V50ToMe',
    "sender": "noreply@8088.onmicrosoft.com",
    "receivers": [
                  'dounsk@outlook.com',
                 ],
    "Subject":"[Note] The key file failed to be created",
	"Content":date + " Please note that the shared directory cannot be accessed and the key file creation fails." +"\r\n"+ "Path:" + path,
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
            print('Failed，Error：{}'.format(e))

    def run(self):
        user_message = self.get_content()
        user_receivers = mail_set['receivers']
        self.send(user_message, user_receivers)

if os.path.exists(path):
	folder = random.choice(os.listdir(path))
	file = str(folder)+'/'+str(uuid.uuid4())+'.key'
	with open(path+file, 'w', encoding='utf-16') as file_object:
		file_object.write(BEGIN)
		for i in range(25):
			for i in random.sample('QWERTYU+IOPqwertyuiop/ASDFGHJKLasdfghjklZXCVBNM/zxcvbnm+QWERTYU+IOPqwertyuiop/ASDFGHJKLasdfghjklZXCVBNM/zxcvbnm+',65):
				file_object.write(i)
			file_object.write("\n")
		file_object.write(END)
	file_object.close()
	print ("The key file is created successfully!")
else:
	app = SendMail()
	app.run()
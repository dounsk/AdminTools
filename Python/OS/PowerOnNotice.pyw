#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-11-10 17:51:30
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$


import os
import time
import smtplib
import subprocess
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

#run Get-ComputerInfo
process=subprocess.Popen(["powershell","Get-ComputerInfo -Property  CsName, WindowsProductName, OsVersion, CsDomain,CsModel, CsSystemType, WindowsRegisteredOwner, CsUserName, CsTotalPhysicalMemory, OsFreePhysicalMemory, OsLastBootUpTime, OsUptime > $Env:TEMP\ComputerInfo.txt"],stdout=subprocess.PIPE);
result=process.communicate()[0]

filename = os.getenv("TEMP")+"\\ComputerInfo.txt"
with open(filename, 'r', encoding='utf-16') as file_object:
	ComputerInfo = file_object.read()
	info = ComputerInfo.split('\n')

mail_set = {
    "host": "smtp.office365.com",
    "pwd": 'KFCrazy4V50ToMe',
    "sender": "noreply@8088.onmicrosoft.com",
    "receivers": [
                  'dounsk@outlook.com',
                 ],
    "Subject":"Notifies that the workstation is powered on",
	"Content":('Dear Admin' + '<br>' +
		'Please know that the workstation you own is powered on, here are the details. Thanks a lot.' + '<br>' +
		info[0] + '<br>' +
		info[1] + '<br>' +
		info[2] + '<br>' +
		info[3] + '<br>' +
		info[4] + '<br>' +
		info[5] + '<br>' +
		info[6] + '<br>' +
		info[7] + '<br>' +
		info[8] + '<br>' +
		info[9] + '<br>' +
		info[10] + '<br>' +
		info[11] + '<br>' +
		info[12] + '<br>' +
		info[13] + '<br>' +
		info[14] + '<br>' ),
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

#clear temp files
time.sleep(3)
os.path.exists(filename)
os.remove(filename)
'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-03-03 15:12:24
FilePath     : \Scripts\Python\Tools\keepalive.py
Description  : admin keep alive
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import os
import uuid
import time
import configparser
import platform
import datetime
import smtplib
from email.mime.text import MIMEText

# SMTP Email
def smtp_sendemail(mail_to, subject, content):
    msg = MIMEText(content, 'html')
    msg['From'] = 'noreply@8088.onmicrosoft.com'
    msg['To'] = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('smtp.office365.com', 587)
    server.starttls() 
    server.login('noreply@8088.onmicrosoft.com', 'KFCrazy4V50ToMe')
    server.sendmail('noreply@8088.onmicrosoft.com',mail_to, msg.as_string())
    server.quit()

path = '//10.122.84.180//QlikSenseSharedPersistence//Apps/Search//'

if os.access(path, os.F_OK):
    System_info = {
    'system'      : platform.system(),
    'architecture': platform.architecture,
    'updated'     : datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
    'value'       : uuid.uuid4()
    }

    config = configparser.ConfigParser()
    config['SystemInfo'] = System_info
    # 更新配置文件
    with open(path+'config.ini', 'w') as configfile:
        config.write(configfile)
    
    time.sleep(3)
    # 检查配置文件内容
    with open(path+'config.ini', 'r') as f:
        content = f.read()
        content = content.replace('\n', '<br>')
    content += "<i> The current task is run by the " + os.getlogin() + " from the " + os.getcwd()
    # 设置邮件标题
    subject = 'Updated SystemInfo '+time.strftime('%Y/%m/%d %H:%M:%S')
    print(subject)

else:
    content  = 'The specified directory cannot be accessed. <br>'
    content += path+'<br>'
    content += "<i> The current task is run by the " + os.getlogin() + " from the " + os.getcwd()
    subject  = 'Inaccessible '+time.strftime('%Y/%m/%d %H:%M:%S')
    print('The path does not exist')


if __name__ == '__main__':
    mail_to = 'dounsk@outlook.com'
    smtp_sendemail(mail_to, subject, content)
    print('The email was sent successfully')
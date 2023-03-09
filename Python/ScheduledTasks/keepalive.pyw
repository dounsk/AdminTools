'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-03-08 11:03:30
FilePath     : \Scripts\Python\ScheduledTasks\keepalive.pyw
Description  : admin keep alive 定时推迟执行的目标日期
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import os
import time
import datetime
import smtplib
import hashlib
import configparser
from email.mime.text import MIMEText

# SMTP Email
def smtp_sendemail(mail_to, subject, content):
    msg            = MIMEText(content, 'html')
    msg['From']    = 'noreply@8088.onmicrosoft.com'
    msg['To']      = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('smtp.office365.com', 587)
    server.starttls() 
    server.login('noreply@8088.onmicrosoft.com', 'KFCrazy4V50ToMe')
    server.sendmail('noreply@8088.onmicrosoft.com',mail_to, msg.as_string())
    server.quit()
    print('The email was sent successfully')

def config_key(keywords, key_file_path):
    keywords_bytes = keywords.encode()
    hash_obj       = hashlib.md5(keywords_bytes)
    key            = hash_obj.hexdigest()[:16]
    System_info    = {
        'system'      : 'Windows',
        'architecture': 'function architecture at 0x0000017088676B901',
        'updated'     : datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'value'       : key
        }
    config               = configparser.ConfigParser()
    config['SystemInfo'] = System_info
    # 保存配置文件
    with open(key_file_path, 'w') as configfile:
        config.write(configfile)

def delay(days_num):
    today = datetime.date.today()
    month_later = today + datetime.timedelta(days=days_num)
    date_month_later = month_later.replace(day=1).strftime('%Y-%m-%d')
    return date_month_later

if __name__ == '__main__':
    path     = '//10.122.84.180//QlikSenseSharedPersistence//Apps/Search//'
    # !             ---
    keywords = delay(99)
    # !             ---
    if os.access(path, os.F_OK):
        config_key(keywords, path+'config.ini')
        time.sleep(3)
        # 检查配置文件内容
        with open(path+'config.ini', 'r') as f:
            content = f.read()
            content = content.replace('\n', '<br>')
        # 设置邮件标题
        subject = 'Updated Target - '+ keywords
        print(subject)
    else:
        content = 'The specified directory cannot be accessed. <br>' + path
        subject = 'Inaccessible '+ keywords
        print('The path does not exist')
        
    mail_to = 'dounsk@outlook.com'
    smtp_sendemail(mail_to, subject, content)
'''
Author       : Kui.Chen
Date         : 2023-03-03 14:56:17
LastEditors  : Kui.Chen
LastEditTime : 2023-06-06 10:58:45
FilePath     : \Scripts\Python\SMTP\miniSMTP.py
Description  : 最小化 SMTP 邮件发送任务
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

import smtplib
from email.mime.text import MIMEText

# SMTP Email
def office365_smtp_sendemail(mail_to, subject, content):
    msg = MIMEText(content, 'html')
    msg['From'] = 'noreply@8088.onmicrosoft.com'
    msg['To'] = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('smtp.office365.com', 587)
    server.starttls() 
    server.login('noreply@8088.onmicrosoft.com', 'KFCrazy4V50ToMe')
    server.sendmail('noreply@8088.onmicrosoft.com',mail_to, msg.as_string())
    server.quit()

# SMTP Email
def lenovo_smtp_sendemail(mail_to, subject, content):
    msg = MIMEText(content, 'html', 'utf-8')
    msg['From'] = 'qlikplatform@lenovo.com'
    msg['To'] = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('Smtpinternal.lenovo.com', 25)
    server.starttls() 
    server.login('qlikplatform@lenovo.com', 'CgFU-2202')
    server.sendmail('qlikplatform@lenovo.com',mail_to, msg.as_string())
    server.quit()

mail_to = "kuichen1@lenovo.com; kuichen1@lenovo.com"
subject = 'Mail TEST'
content = 'The email was sent by smtp.office365 <br>'
content += 'Thanks.'

if __name__ == '__main__':
    office365_smtp_sendemail(mail_to, subject, content)
    lenovo_smtp_sendemail(mail_to, subject, content)
    print('The email was sent successfully')
'''
Author       : Kui.Chen
Date         : 2023-03-03 14:56:17
LastEditors  : Kui.Chen
LastEditTime : 2023-03-03 14:59:50
FilePath     : \Scripts\Python\SMTP\miniSMTPo365.py
Description  : 最小化 SMTP 邮件发送任务
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

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

mail_to = 'dounsk@outlook.com'
subject = 'Mail TEST Info '
content = 'The email was sent by smtp.office365 <br>'
content += 'Thanks.'

if __name__ == '__main__':
    smtp_sendemail(mail_to, subject, content)
    print('The email was sent successfully')
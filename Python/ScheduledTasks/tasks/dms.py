'''
Author       : Kui.Chen
Date         : 2023-03-07 15:42:34
LastEditors  : Kui.Chen
LastEditTime : 2023-03-08 11:19:16
FilePath     : \Scripts\Python\ScheduledTasks\dms.py
Description  : Dead Man's Switch
    <<黎明之剑>> 
    “在出发之前，我已经把塔尔隆德设定为十二颗卫星以及三座空间站的坠落目标，只等协议生效，起航者的遗产便会从天而降。”
    “我想问一下，塔尔隆德大护盾能挡住它们么？”
    “你搞错了一件事，我并不需要下达废弃协议的指令 ——我已经下达指令了。而我这些天在做的，就是每十二个小时将它们推迟一次。”
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
# ! 先决条件，设置解码文件的目标日期: Python\ScheduledTasks\keepalive.pyw

import base64
import configparser
from Crypto.Cipher import AES

def encrypt(data, key):
    cipher = AES.new(key, AES.MODE_EAX)
    ciphertext, tag = cipher.encrypt_and_digest(data.encode())
    return base64.b64encode(cipher.nonce + tag + ciphertext).decode()

def write_file(data, file_path):
    with open(file_path, "wb") as f:
        f.write(data.encode())

def key(key_file_path):
    config = configparser.ConfigParser()
    config.read(key_file_path)
    value = config.get('SystemInfo', 'value')
    key = value.encode('utf-8')
    return key

if __name__ == "__main__":
    key_file_path = "//10.122.84.180//QlikSenseSharedPersistence//Apps//Search//config.ini"
    key = key(key_file_path)
    # 需要加密数据的数据
    data = """
import smtplib
from email.mime.text import MIMEText

# SMTP Email
def smtp_sendemail(mail_to, subject, content):
    msg = MIMEText(content, 'html')
    msg['From'] = 'flexreport@lenovo.com'
    msg['To'] = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('smtpinternal.lenovo.com', 25)
    server.starttls() 
    server.login('qlikplatform@lenovo.com', 'CgFU-2202')
    server.sendmail('flexreport@lenovo.com',mail_to, msg.as_string())
    server.quit()

mail_to = 'dounsk@outlook.com'
subject = 'Successfully'
content = 'The data is decrypted successfully. <br>'
content += 'Thanks.'

if __name__ == '__main__':
    smtp_sendemail(mail_to, subject, content)

    """
    encrypted_data = encrypt(data, key)
    # 将加密后的数据写入文件
    encrypted_file_path = "//10.122.36.130//Log//AppMigration//9b92c0c5-cb31-4fed-8ba1-dbd404a03c30.qvf"
    write_file(encrypted_data, encrypted_file_path)
    print("The data has been encrypted and saved to:"+ encrypted_file_path)
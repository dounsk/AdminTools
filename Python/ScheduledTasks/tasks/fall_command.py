'''
Author       : Kui.Chen
Date         : 2023-03-07 16:34:50
LastEditors  : Kui.Chen
LastEditTime : 2023-03-08 11:21:10
FilePath     : \Scripts\Python\ScheduledTasks\fall_command.py
Description  : 获取 Key 并执行解密，解密成功则转换为脚本执行。
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import os
import sys
import base64
import datetime
import hashlib
from Crypto.Cipher import AES

def decrypt(data, key):
    data = base64.b64decode(data.encode())
    nonce, tag, ciphertext = data[:16], data[16:32], data[32:]
    cipher = AES.new(key, AES.MODE_EAX, nonce=nonce)
    plaintext = cipher.decrypt_and_verify(ciphertext, tag)
    return plaintext.decode()

def write_file(data, file_path):
    with open(file_path, "wb") as f:
        f.write(data.encode())

def read_file(file_path, key):
    with open(file_path, "rb") as f:
        data = f.read()
    return decrypt(data.decode(), key)

def key(keywords):
    keywords_bytes = keywords.encode()
    hash_obj       = hashlib.md5(keywords_bytes)
    key            = hash_obj.hexdigest()[:16]
    return key

if __name__ == "__main__":
    keywords = datetime.datetime.now().strftime('%Y-%m-%d')
    key = key(keywords).encode('utf-8')
    encrypted_file_path = "//10.122.36.130//Log//AppMigration//9b92c0c5-cb31-4fed-8ba1-dbd404a03c30.qvf"
    try:
        decrypted_data = read_file(encrypted_file_path, key)
        # print("解密后的数据：", decrypted_data)
        code_str = decrypted_data
        # 将字符转换为代码执行
        code = compile(code_str, '<string>', 'exec')
        exec(code) 
    except Exception as e:
        # 如果发生异常，则打印错误消息并退出程序
        print("failed: ", e)
        sys.exit()

    os.remove(encrypted_file_path)
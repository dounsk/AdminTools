import base64
import datetime
import hashlib
import configparser
from Crypto.Cipher import AES

# 定义加密函数
def encrypt(data, key):
    cipher = AES.new(key, AES.MODE_EAX)
    ciphertext, tag = cipher.encrypt_and_digest(data.encode())
    return base64.b64encode(cipher.nonce + tag + ciphertext).decode()

# 定义解密函数
def decrypt(data, key):
    data = base64.b64decode(data.encode())
    nonce, tag, ciphertext = data[:16], data[16:32], data[32:]
    cipher = AES.new(key, AES.MODE_EAX, nonce=nonce)
    plaintext = cipher.decrypt_and_verify(ciphertext, tag)
    return plaintext.decode()

# 定义写入文件函数，将加密后的数据写入文件中
def write_file(data, file_path):
    with open(file_path, "wb") as f:
        f.write(data.encode())

# 定义读取文件函数，从文件中读取数据并解密
def read_file(file_path, key):
    with open(file_path, "rb") as f:
        data = f.read()
    return decrypt(data.decode(), key)

def key(key_file_path):
    config = configparser.ConfigParser()
    config.read(key_file_path)
    value = config.get('SystemInfo', 'value')
    key = value.encode('utf-8')
    return key

def config_key(keywords, key_file_path):
    keywords_bytes = keywords.encode()
    # 使用MD5算法对字节串进行哈希
    hash_obj = hashlib.md5(keywords_bytes)
    # 获取哈希值，并取前16位作为key
    key = hash_obj.hexdigest()[:16]
    System_info = {
        'system'      : 'Windows',
        'architecture': 'function architecture at 0x0000017088676B901',
        'updated'     : datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'value'       : key 
        }
    config = configparser.ConfigParser()
    config['SystemInfo'] = System_info
    # 保存配置文件
    with open(key_file_path, 'w') as configfile:
        config.write(configfile)

if __name__ == "__main__":
    # 1. 定义固定密钥key (16位)
    # key = b"010-123400ees651"
    # 2. 使用日期关键词保存 Key 值到 config 文件中 config_key
    keywords = datetime.datetime.now().strftime('%Y-%m-%d')
    key_file_path = "Python\\temp\\config.ini"
    config_key(keywords, key_file_path)

    key = key(key_file_path)
    # 需要加密数据的数据
    data = """
        File Browser 
        Top → pgadmin → pgadmin4 → v6.20 → windows
        Directories
        [Parent Directory] [Parent Directory]
        Files
        CURRENT_MAINTAINER CURRENT_MAINTAINER	2023-02-09 10:54:04	136 bytes
        pgadmin4-6.20-x64.exe pgadmin4-6.20-x64.exe	2023-02-09 10:54:23	164.9 MB
        Current Maintainer
        Support: pgadmin-support@lists.postgresql.org
        Website: https://www.pgadmin.org/
        Tracker: https://github.com/pgadmin-org/pgadmin4/issues
    """
    encrypted_data = encrypt(data, key)
    print("加密后的数据：", encrypted_data)
    # 将加密后的数据写入文件
    encrypted_file_path = "Python\\temp\\encrypted_data.txt"
    write_file(encrypted_data, encrypted_file_path)

    # 从文件中读取数据并解密
    decrypted_data = read_file(encrypted_file_path, key)
    print("解密后的数据：", decrypted_data)
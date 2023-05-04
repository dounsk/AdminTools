'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-04-24 17:36:37
FilePath     : \Scripts\Python\Tools\CreateSSL.py
Description  : 自签发一个SSL证书
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''

from OpenSSL import crypto
# 预设证书信息
COUNTRY_NAME = "CN"
STATE_OR_PROVINCE_NAME = "Beijing"
LOCALITY_NAME = "Beijing"
ORGANIZATION_NAME = "Lenovo (Beijing) Limited"
ORGANIZATIONAL_UNIT_NAME = "Lenovo (Beijing) Limited"
COMMON_NAME = "monitor.qliksense.lenovo.com"
EMAIL_ADDRESS = "qlikplatform@lenovo.com"
# 生成私钥
key = crypto.PKey()
key.generate_key(crypto.TYPE_RSA, 2048)
# 生成证书请求
req = crypto.X509Req()
subject = req.get_subject()
subject.C = COUNTRY_NAME
subject.ST = STATE_OR_PROVINCE_NAME
subject.L = LOCALITY_NAME
subject.O = ORGANIZATION_NAME
subject.OU = ORGANIZATIONAL_UNIT_NAME
subject.CN = COMMON_NAME
subject.emailAddress = EMAIL_ADDRESS
req.set_pubkey(key)
req.sign(key, "sha256")
# 生成自签名证书
cert = crypto.X509()
cert.set_subject(subject)
cert.set_issuer(subject)
cert.set_pubkey(key)
cert.gmtime_adj_notBefore(0)
cert.gmtime_adj_notAfter(365 * 24 * 60 * 60)  # 证书有效期一年
cert.sign(key, "sha256")
# 将私钥和证书保存到文件中
with open("monitor.qliksense.lenovo.com.key", "wb") as f:
    f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, key))
with open("monitor.qliksense.lenovo.com.crt", "wb") as f:
    f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
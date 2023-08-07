'''
Author       : Kui.Chen
Date         : 2022-10-19 16:56:14
LastEditors  : Kui.Chen
LastEditTime : 2023-05-29 17:50:27
FilePath     : \Scripts\Python\Tools\SSL_certificate_check.py
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import ssl
import pytz
import socket
import smtplib
import OpenSSL
import subprocess
from datetime import datetime
from email.mime.text import MIMEText

# 定义 ssl 证书查询剩余有效期天数
check_SSL_days_left = 30
# 定义要查询的URL列表
url_list = [
    "app.qliksense.lenovo.com",
    "app1.qliksense.lenovo.com",
    "app2.qliksense.lenovo.com",
    "app3.qliksense.lenovo.com",
    "app5.qliksense.lenovo.com",
    # "app6.qliksense.lenovo.com",
    # "app7.qliksense.lenovo.com",
    "app8.qliksense.lenovo.com",
    "app9.qliksense.lenovo.com",
    # "app10.qliksense.lenovo.com",
    "app11.qliksense.lenovo.com",
    "app12.qliksense.lenovo.com",
    "app13.qliksense.lenovo.com",
    "app15.qliksense.lenovo.com",
    "app16.qliksense.lenovo.com",
    "app17.qliksense.lenovo.com",
    # "app18.qliksense.lenovo.com"
]

# 设置超时时间
timeout = 5
ip_role_map = {
    "10.122.36.100" : "[PRD] Proxy Engine 04",
    "10.122.36.106" : "[PRD] Proxy Engine 05",
    "10.122.36.107" : "[PRD] Proxy Engine 01",
    "10.122.36.108" : "[PRD] Proxy Engine 02",
    "10.122.36.109" : "[PRD] Proxy Engine 03",
    "10.122.36.110" : "[PRD] API 02",
    "10.122.36.117" : "[PRD]Database",
    "10.122.36.119" : "[PRD] API 01",
    "10.122.36.120" : "[PRD] Central Master & Scheduler Master",
    "10.122.36.121" : "[PRD] Scheduler 05",
    "10.122.36.122" : "[PRD] Central Candidate & Scheduler 01",
    "10.122.36.123" : "[PRD] Scheduler 02",
    "10.122.36.124" : "[PRD] Scheduler 03",
    "10.122.36.130" : "[PRD] Sense NPrinting",
    "10.122.36.220" : "[PRD] Scheduler 04",
    "10.122.36.111" : "[DEV] Central Master & Scheduler Master",
    "10.122.36.112" : "[DEV] Central Candidate & Scheduler 01",
    "10.122.36.114" : "[DEV] Proxy Engine 01",
    "10.122.36.115" : "[DEV] Proxy Engine 02",
    "10.122.36.116" : "[DEV] Proxy Engine 03",
    "10.122.36.128" : "[DEV] Scheduler 02"
}
# Mail Content
content = """
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <style>
      table {
        border-collapse: collapse;
        width: 100%;
      }
      th, td {
        text-align: left;
        padding: 8px;
        border-bottom: 1px solid #ddd;
      }
      tr:hover {background-color:#f5f5f5;}
      th {
        background-color: #106ebe;
        color: white;
      }
      th.center {
        text-align: center;
      }
      strong {
        color: red;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <p>Dear Admin,</p>
    <p>We have detected the following SSL certificates that will expire within """+ str(check_SSL_days_left) +""" days. Please make sure to renew these certificates as soon as possible to avoid any potential security risks or service interruptions. Thanks.</p>
    <table>
      <thead>
        <tr>
          <th>URL</th>
          <th>IP Address</th>
          <th>Role</th>
          <th>Date of issue</th>
          <th>Expiration date</th>
          <th class="center">Days Left</th>
          <th>Organization</th>
          <th>Issuer</th>
          <th>Error</th>
        </tr>
      </thead>
"""

# 遍历URL列表
for url in url_list:
    print("Checking...  " + url)
    process = subprocess.Popen(["ping", url], stdout=subprocess.PIPE)
    output, error = process.communicate()
    # 解析命令输出，获取IP地址
    output = output.decode('utf-8')
    if '[10.' in output:
        start = output.find('[') + 1
        end = output.find(']')
        ip = output[start:end]
    else:
        ip = "Not Found"
    try:
        # 获取域名和端口号
        if ":" in url:
            host, port = url.split(":")
        else:
            host = url
            port = 443  # 默认端口为443
        # 建立socket连接
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        sock.connect((host, int(port)))
        # 创建SSLContext对象
        context = ssl.create_default_context()
        # 获取证书
        with context.wrap_socket(sock, server_hostname=host) as sslsock:
            cert = sslsock.getpeercert(True)
            # 解析证书
            x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_ASN1, cert)
            subject = dict(x509.get_subject().get_components())
            subject_components = []
            for k, v in subject.items():
                subject_components.append((k.decode(), v.decode()))
            issuer = dict(x509.get_issuer().get_components())
            issuer_components = []
            for k, v in issuer.items():
                issuer_components.append((k.decode(), v.decode()))
            not_before = datetime.strptime(x509.get_notBefore().decode('ascii'), '%Y%m%d%H%M%S%z')
            not_after = datetime.strptime(x509.get_notAfter().decode('ascii'), '%Y%m%d%H%M%S%z')
    except Exception as e:
        error = e
    finally:
        sock.close()
    role = ip_role_map[ip]
    dt = datetime.now()
    utc = pytz.utc
    dt_with_utc_tz = utc.localize(dt)
    days_left = (not_after - dt_with_utc_tz).days
    # 检查证书有效期剩余天数
    if days_left < check_SSL_days_left:
        notice = True
    #     print(url, ip, role, not_before, not_after,days_left, subject_components[2][1], issuer_components[1][1],error)
        content += "<tbody>"
        content +=    "<tr>"
        content +=      "<td>"+url+"</td>"
        content +=      "<td>"+ip+"</td>"
        content +=      "<td>"+role+"</td>"
        content +=      "<td>"+str(not_before)+"</td>"
        content +=      "<td>"+str(not_after)+"</td>"
        content +=      '<td class="center"><strong>'+str(days_left)+'</strong></td>'
        content +=      "<td>"+subject_components[2][1]+"</td>"
        content +=      "<td>"+issuer_components[1][1]+"</td>"
        content +=      "<td>"+str(error)+"</td>"
        content +=    "</tr>"
        content +=  "</tbody>"
    else:
        notice = False

content += """
    </table>
  </body>
</html>
"""
# mail_to = "yuhao5@lenovo.com; qlikplatform@lenovo.com; maxx1@lenovo.com; kuichen1@lenovo.com"
mail_to = "kuichen1@lenovo.com"
subject = '[Note!] The SSL certificates will expire within ' + str(check_SSL_days_left) +' days'

# SMTP Email
def smtp_sendemail(mail_to, subject, content):
    msg = MIMEText(content, 'html', 'utf-8')
    msg['From'] = 'qlikplatform@lenovo.com'
    msg['To'] = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('Smtpinternal.lenovo.com', 25)
    server.starttls() 
    server.login('qlikplatform@lenovo.com', 'CgFU-2202')
    server.sendmail('qlikplatform@lenovo.com',mail_to, msg.as_string())
    server.quit()

if notice:
    smtp_sendemail(mail_to, subject, content)
    print('The email was sent successfully.')
else:
    print('Check that no certificates have expired.')
    
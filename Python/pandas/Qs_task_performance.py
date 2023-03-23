'''
Author       : Kui.Chen
Date         : 2023-03-17 09:59:42
LastEditors  : Kui.Chen
LastEditTime : 2023-03-23 11:22:26
FilePath     : \Scripts\Python\pandas\Qs_task_performance.py
Description  : 使用 pandas 从共享目录获取 QS Task Scheduler load 数据并通过邮件发送给接用户
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import pandas as pd
import matplotlib.pyplot as plt
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
import datetime

# 时间 🕙
date = datetime.datetime.now().strftime('%Y%m%d') 
# source_file = "//10.122.36.118/QlikOperations/QsTaskStatus/QlikSense_TaskStatus_" + date + ".csv"
source_file = "Python\Data\get\merged_file_20230323111953.csv"
# 读取CSV文件数据
df = pd.read_csv(source_file, usecols=["DateTime", "Started_Number", "Queued_Number", "ExecutingNodeName"])
# 将DateTime列转换为datetime类型，并设置为索引
df["DateTime"] = pd.to_datetime(df["DateTime"])
df.set_index("DateTime", inplace=True)
# 获取不同的ExecutingNodeName列表
node_list = df["ExecutingNodeName"].unique()
# 创建邮件正文
msg = MIMEMultipart()
# 邮件收发信息
msg['Subject'] = 'Update: QlikSense Task Scheduler Load'
msg['From'] = 'qlikplatform@lenovo.com'
msg['To'] = 'kuichen1@lenovo.com'
# 预设邮件 Html 标头
html = """<head>
    <meta charset="UTF-8">
    <title>QlikSense Task Scheduler Executing Performance</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #333;
            background-color: #f5f5f5;
            text-align: center;
        }
        .container {
            max-width: 700px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,.1);
            text-align: left;
        }
        h1 {
            font-size: 24px;
            font-weight: bold;
            margin: 0 0 20px;
            text-align: center;
        }
        h2 {
            font-size: 18px;
            font-weight: bold;
            margin: 20px 0 10px;
        }
        p {
            margin: 10px 0;
        }
        ul {
            margin: 10px 0;
            padding: 0;
            list-style: none;
        }
        li:before {
            content: "• ";
            color: #999;
        }
        img {
            max-width: 100%!;
            height: auto;
            margin: 20px 0;
        }
        .disclaimer {
            font-size: 12px;
            color: #999;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>"""
html += '<html><body>'

# 遍历不同的ExecutingNodeName
task_Queued = ""
fig, axs = plt.subplots(nrows=2, ncols=1, figsize=(18, 6), sharex=True)
for node_name in node_list:
    # 选择当前节点的数据
    node_data = df[df["ExecutingNodeName"] == node_name].copy()
    
    # 检查节点数据是否包含Date和Time列
    if "Date" not in node_data.index.names:
        node_data.loc[:, "Date"] = node_data.index.date
    if "Time" not in node_data.index.names:
        node_data.loc[:, "Time"] = node_data.index.time
        
    # 绘制Started_Number和Queued_Number的折线图
    # node_data["Started_Number"].plot(ax=axs[0], label="{} - Started_Number".format(node_name))
    # node_data["Queued_Number"].plot(ax=axs[1], label="{} - Queued_Number".format(node_name))
    node_data["Started_Number"].plot(ax=axs[0], label="{}".format(node_name))
    node_data["Queued_Number"].plot(ax=axs[1], label="{}".format(node_name))

    # 计算Queued_Number的最大值和对应的时间
    max_queued_number = node_data["Queued_Number"].max()
    max_date = node_data["Date"][node_data["Queued_Number"].idxmax()]
    max_time = node_data["Time"][node_data["Queued_Number"].idxmax()]

    # list 每个 node 最大排队数量
    task_Queued += "<li> The max queued task for {} is <b> {} </b> at <b>{} {} </b></li>".format(node_name, max_queued_number, max_date, max_time)
    
# 设置图例和标题
axs[0].set_title("Started_Number vs. Time")
axs[1].set_title("Queued_Number vs. Time")
handles, labels = axs[0].get_legend_handles_labels()
fig.legend(handles, labels, loc='right')
    # 将折线图保存为图片，并将其添加到邮件正文中
fig.savefig("{}.png".format(node_name))
with open("{}.png".format(node_name), 'rb') as f:
    img_data = f.read()
image = MIMEImage(img_data)
image.add_header('Content-ID', '<{}>'.format(node_name))
msg.attach(image)

disclaimer = """This email is from an unmonitored mailbox. You are receiving this email because you have been identified as a key user associated with this service and have been notified of changes to the service. 
If you have received this email in error, please notify us immediately and delete this email permanently."""
date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') 
# 将折线图添加到HTML邮件
html += "<h1>{}</h1>".format("QlikSense Task Scheduler Executing Performance")
html += '<p>{}</p>'.format(date)
html += '<p>{}</p>'.format("We wanted to provide you with an update on today's QlikSense task scheduler load. To help you stay informed, please see the maximum node queues listed below. If you have any questions or concerns regarding this information, please don't hesitate to reach out to us. Thanks.")
html += task_Queued
html += '<h2>{}</h2>'.format("Performance Metrics")
html += '<img src="cid:{}">'.format(node_name)
html += '<p class="disclaimer"><i>{}</i></p>'.format(disclaimer)
html += '</body></html>'
plt.close()
# 将HTML邮件正文添加到邮件中
msg.attach(MIMEText(html, 'html'))
# 发送邮件
with smtplib.SMTP('Smtpinternal.lenovo.com', 25) as smtp:
    smtp.starttls()
    smtp.login('qlikplatform@lenovo.com', 'CgFU-2202')
    smtp.send_message(msg)
    smtp.quit

print('Done! The email has been successfully sent to ' + msg['To'])
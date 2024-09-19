# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/9/19 下午2:26 星期四
Project      : AdminTools
FilePath     : admin_tools/test/group_by
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import pandas as pd

# 从CSV文件读取数据
data = pd.read_csv(r"C:\Users\douns\Downloads\Sharing_Data_Permissions.csv")

# 使用逗号将Identity列中的值连接在一起，并按Directory列对其进行分组
grouped_data = data.groupby('Directory')['Identity'].apply(lambda x: ','.join(x)).reset_index()

# 将结果写入新的CSV文件
grouped_data.to_csv('output.csv', index=False)

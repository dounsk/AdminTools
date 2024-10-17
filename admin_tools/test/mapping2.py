# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/9/19 下午2:41 星期四
Project      : AdminTools
FilePath     : admin_tools/test/mapping2
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import pandas as pd

# 读取Excel文件中的两个工作表
sheet0 = pd.read_excel(r"C:\Users\douns\OneDrive - 8088\桌面\SYPQLIKSENSE02_SystemFileSizeCheck_2024-09-18.csv.xlsx",
                       sheet_name='Sheet0')
sheet1 = pd.read_excel(r"C:\Users\douns\OneDrive - 8088\桌面\SYPQLIKSENSE02_SystemFileSizeCheck_2024-09-18.csv.xlsx",
                       sheet_name='Sheet1')


# 定义一个函数，用于查找包含目录的Identity
def find_identity(full_path):
    for index, row in sheet1.iterrows():
        if row['Directory'] in full_path:
            return row['Identity']
    return None


# 应用函数并将结果写入新列
sheet0['AccessPermissions'] = sheet0['FullPath'].apply(find_identity)

# 将结果写入新的Excel文件
with pd.ExcelWriter('output.xlsx', engine='openpyxl') as writer:
    sheet0.to_excel(writer, sheet_name='Sheet0', index=False)
    sheet1.to_excel(writer, sheet_name='Sheet1', index=False)

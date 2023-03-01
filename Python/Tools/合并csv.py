'''
Author: Kui.Chen
Date: 2023-02-28 10:56:21
LastEditors: Kui.Chen
LastEditTime: 2023-02-28 15:01:32
FilePath: \Scripts\Python\Tools\合并csv.py
Description: 合并指定文件夹中的csv文件
Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
# import necessary libraries 
import os
import pandas as pd 
from datetime import datetime

# ^ ------------------------------------------------------------------------
# ! 确认并修改为需要的路径和文件类型
scan_directory = 'C:\\Users\\douns\\Downloads\\csv'
file_type = ".csv"
export_directory = 'C:\\Users\\douns\\Downloads'
# ^ ------------------------------------------------------------------------

suffix      = datetime.now().strftime('%Y%m%d%H%M%S')
export_file = export_directory + '\\merged_file_' + suffix +'.csv'
# create an empty dataframe 
df_merged = pd.DataFrame()
files     = os.listdir(scan_directory)
# ? loop through the filenames list and read each csv file 
for file in files:
    if file.endswith(file_type): 
        df = pd.read_csv(scan_directory + '/' + file)
        # append the data from each file into the empty dataframe 
        df_merged = pd.concat([df_merged, df])
# save the merged dataframe to a new csv file 
df_merged.to_csv(export_file, index=False)

# print ("-- The Merge Data Has Completed. --".upper())
print ("\033[33m {}\033[00m".format("-- The Merge Data Has Completed. --"))
    # ? Python中可以使用ANSI颜色代码来打印不同颜色的字符串，代码格式如下：
    # \033[<color_code>m<string>\033[00m
    # 其中<color_code>可以是以下值：
    # 30：黑色
    # 31：红色
    # 32：绿色
    # 33：黄色
    # 34：蓝色
    # 35：紫色
    # 36：青色
    # 37：白色

# ^ open export directory
os.startfile(export_directory)
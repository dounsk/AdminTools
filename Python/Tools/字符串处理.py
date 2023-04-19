'''
Author       : Kui.Chen
Date         : 2023-03-09 17:01:59
LastEditors  : Kui.Chen
LastEditTime : 2023-03-27 14:29:21
FilePath     : \Scripts\Python\Tools\字符串处理.py
Description  : 字符串处理
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
mixedString = '''

There are no limits:
No action required:
Close and ignore the prompt:

''' 
# 转换为全部大写
UpperString = mixedString.upper()
# 转换为全部小写
lowerString = mixedString.lower()
# 转换为首字母大写  
capitalizedString = lowerString.title()

# 打印首字母大写
print("\033[32m {}\033[00m".format('首字母大写：' +
    capitalizedString))
# 打印全大写
print("\033[33m {}\033[00m".format('全大写：' +
    UpperString))
# 打印全小写
print("\033[34m {}\033[00m".format('全小写：' +
    lowerString))
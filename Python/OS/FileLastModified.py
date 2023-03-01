#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-11-09 11:02:32
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$


import os
import datetime


def modification_date(filename):
    time = os.path.getmtime(filename)
    return datetime.datetime.fromtimestamp(time)

today = datetime.datetime.now().strftime('%Y-%m-%d')
# LastModified = modification_date('/OneDrive - 8088/Kuii/Taotao/Taotao.docx').strftime('%Y-%m-%d')
LastModified = modification_date('/OneDrive - 8088/Kuii/Taotao/1.txt').strftime('%Y-%m-%d')
print ("today:"+today)
print ("LastModified:"+LastModified)
if LastModified == today:
	# os.system('copy "/OneDrive - 8088/Kuii/Taotao/1.txt" "/OneDrive - 8088/Kuii/Taotao/Backup/1(bak).txt"')
	# os.system("xcopy D:/OneDrive - 8088/Kuii/Taotao/1.txt D:/OneDrive - 8088/Kuii/Taotao/Backup/1(bak).txt")
	print("Check for file updates, perform backups.")
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-11-10 14:21:22
# @Author  : kui (🌻)
# @Link    : 🖐
# @Version : $Id$

import os
import subprocess
import time

#run powershell
process=subprocess.Popen(["powershell","Get-ComputerInfo -Property '*' > D:\py\ComputerInfo.txt"],stdout=subprocess.PIPE);
result=process.communicate()[0]
# print (result)

file = "D:\py\ComputerInfo.txt"

with open(file, encoding='utf-16') as file_object:
	lines = file_object.readlines()
	for info in lines:
		if 'WindowsProductName' in info:
			WindowsProductName = info
			pass
		if 'WindowsRegisteredOwner' in info:
			WindowsRegisteredOwner = info
			pass
		if 'CsDomain' in info:
			CsDomain = info
			pass

print(WindowsProductName, WindowsRegisteredOwner, CsDomain)

time.sleep(3)

#remove temp files
os.path.exists(file)
os.remove(file)
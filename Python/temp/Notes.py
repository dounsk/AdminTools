#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2022-10-19 14:41:09
# @Author  : kui (👍)
# @Link    : Crazy Thursday V5🖐
# @Version : 1.1

# !
# ?
# *
# ^
# &
# todo
# //

#---日期时间---
import datetime
date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') #时间🕙
num = int(datetime.datetime.now().strftime('%H'))-9 #时间计算

import time
localtime = time.localtime(time.time())
print(localtime) 
#time.struct_time(tm_year=2022, tm_mon=10, tm_mday=20, tm_hour=14, tm_min=37, tm_sec=27, tm_wday=3, tm_yday=293, tm_isdst=0)
print(localtime.tm_year) #YYYY
print(localtime.tm_mon) #MM
print(localtime.tm_mday) #DD

localtime = time.localtime(time.time())
asctime = time.asctime(localtime)
print(asctime) #Thu Oct 20 14:37:27 2022
strtime = time.strftime('%Y-%m-%d %H:%M:%S', localtime)
print(strtime) #2022-10-20 14:37:27
mydate = time.strptime('2018-1-1', '%Y-%m-%d')
# time.struct_time(tm_year=2018, tm_mon=1, tm_mday=1, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=0, tm_yday=1, tm_isdst=-1)
print(mydate) 

#---5秒内随机休眠---
import time
import random
time.sleep(random.random() * 4 + 1) #小憩片刻

#---随机执行---
from random import randint
face = randint(1, 6)
if face == 1:
    result = '唱首歌'
elif face == 2:
    result = '跳个舞'
elif face == 3:
    result = '学狗叫'
elif face == 4:
    result = '做俯卧撑'
elif face == 5:
    result = '念绕口令'
else:
    result = '讲冷笑话'
print(result)

#---打印多行字符---
print("""
	████████╗██╗  ██╗ █████╗ ███╗   ██╗██╗  ██╗██╗
	╚══██╔══╝██║  ██║██╔══██╗████╗  ██║██║ ██╔╝██║
	   ██║   ███████║███████║██╔██╗ ██║█████╔╝ ██║
	   ██║   ██╔══██║██╔══██║██║╚██╗██║██╔═██╗ ╚═╝
	   ██║   ██║  ██║██║  ██║██║ ╚████║██║  ██╗██╗
	   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝
	""")

#---运算符---
flag1 = 3 > 2 				#True
print("flag1 = ", flag1)
flag2 = 2 < 1 				#False
print("flag2 = ", flag2)
flag3 = flag1 and flag2 	#False
print("flag3 = ", flag3)
flag4 = flag1 or flag2 		#True
print("flag4 = ", flag4)
flag5 = not flag1 			#False
print("flag5 = ", flag5)

#---字符串操作---
str1 = 'hello, world!'
print('字符串的长度是:', len(str1))
print('单词首字母大写: ', str1.title())
print('字符串变大写: ', str1.upper())
# str1 = str1.upper()
print('字符串是不是大写: ', str1.isupper())
print('字符串是不是以hello开头: ', str1.startswith('hello'))
print('字符串是不是以hello结尾: ', str1.endswith('hello'))
print('字符串是不是以感叹号开头: ', str1.startswith('!'))
print('字符串是不是一感叹号结尾: ', str1.endswith('!'))
str2 = '- kuiii'
str3 = str1.title() + ' ' + str2.lower()
print(str3)

# ---格式化输出---
a = int(input('a = '))
b = int(input('b = '))
print('%d + %d = %d' % (a, b, a + b))	#1 + 2 = 3
print('%d - %d = %d' % (a, b, a - b))	# 1 - 2 = -1
print('%d * %d = %d' % (a, b, a * b))	# 1 * 2 = 2
print('%d / %d = %f' % (a, b, a / b))	# 1 / 2 = 0.500000
print('%d // %d = %d' % (a, b, a // b))	# 1 // 2 = 0
print('%d %% %d = %d' % (a, b, a % b))	# 1 % 2 = 1
print('%d ** %d = %d' % (a, b, a ** b))	# 1 ** 2 = 1

# ---检查变量的类型---
a = 100 	#int
b = 100000	#int
c = 12.345	#float
d = 1 + 5j	#complex
e = 'A'		#str
f = 'hello'	#str
g = True 	#bool
print(type(a))

#for ---枚举---
testList = ['nice', 'to', 'meet', 'you']
for i, x in enumerate(testList):
   print(i, x)

# ---用户身份验证---
username = input('请输入用户名: ')
password = input('请输入口令: ')
# 输入口令的时候终端中没有回显
# password = getpass.getpass('请输入口令: ')
if username == 'admin' and password == '123456':
    print('身份验证成功!')
else:
    print('身份验证失败!')

# ---while循环---
sum = 0
num = 1
while num <= 100:
    sum += num
    num += 1
print(sum)

# ---for循环---
for x in range(10):
    print (x)

# ---list---
list1 = list(range(1, 5))
print(list1) # [1, 2, 3, 4]
list2 = [x * x for x in range(1, 5)]
print(list2) # [1, 4, 9, 16]
list3 = [m + n for m in 'ABC' for n in '123']
print(list3) # ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3']
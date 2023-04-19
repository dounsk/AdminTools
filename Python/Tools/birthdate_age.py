'''
Author       : Kui.Chen
Date         : 2023-03-30 09:54:54
LastEditors  : Kui.Chen
LastEditTime : 2023-03-31 10:25:41
FilePath     : \Scripts\Python\Tools\birthdate_age.py
Description  : 计算目标日期与出生日期间隔的实际月历天数
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
def calculate_age(birthdate, targetdate):
    birth = datetime.strptime(birthdate, "%Y-%m-%d").date()
    target = datetime.strptime(targetdate, "%Y-%m-%d").date()
    age = relativedelta(target, birth)
    years = age.years
    months = age.months
    days = age.days
    if years > 0:
        if months == 0 and days == 0:
            if years == 2:
                return "🎂 Happy 2nd birthday!"
            elif years == 3:
                return "🎂 Happy 3rd birthday!"
            else:
                return f"🎂 Happy {years}th birthday!"
            # return f"🐣 {years} years. 🎂 Happy birthday!"
        elif months == 0:
            return f"🐣 {years} years and {days} days."
        elif days == 0:
            return f"🐣 {years} years and {months} months."
        else:
            return f"🐣 {years} years {months} months {days} days."
    else:
        if months == 12 and days == 0:
            return "🎂 Happy 1st birthday!"
        elif months > 0:
            if days == 0:
                return f"🌕 {months} months."
            else:
                return f"🐣 {months} months {days} days."
        else:
            return f"🐣 {days} days."
# 1. 循环计算指定日期范围内日期间隔
# startdate = "2022-10-24"
# enddate = "2025-12-24"
# date = datetime.strptime(startdate, "%Y-%m-%d")
# with open("Pi.Chen_age.txt", "w", encoding='utf-8') as file:
#     file.write("Date\tAge\n")
#     while date <= datetime.strptime(enddate, "%Y-%m-%d"):
#         age = calculate_age("2022-10-24", date.strftime("%Y-%m-%d"))
#         file.write(date.strftime("%Y-%m-%d") + "\t" + age + "\n")
#         date += timedelta(days=1)

# 2. 计算指定日期与生日的间隔日期
birthdate = "2022-10-24"
targetdate = "2023-03-31"
age = calculate_age(birthdate, targetdate)
print (age)

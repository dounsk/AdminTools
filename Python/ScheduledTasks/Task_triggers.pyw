'''
Author       : Kui.Chen
Date         : 2023-01-13 16:31:35
LastEditors  : Kui.Chen
LastEditTime : 2023-03-31 09:47:47
FilePath     : \Scripts\Python\ScheduledTasks\Task_triggers.pyw
Description  : Schedule task triggers
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import time
import schedule
import subprocess

# 运行日志输出路径
log = "D:\OneDrive - 8088\Scripts\Python\ScheduledTasks\ScheduledTaskExecution.Log"

tasks = {
    "minutes_tst": {
    # for test
        "enabled": False,
        "interval": "5 minutes",
        # "script": r"D:\OneDrive - 8088\Scripts\Python\SMTP\miniSMTP.py"
        "script": r"D:\OneDrive - 8088\Scripts\Python\ScheduledTasks\tasks\keepalive.pyw"
    },
    "hourly": {
    # 每小时能干啥？还没有想好，不启用先 😁
        "enabled": False,
        "interval": "hourly at 10 minutes past the hour",
        "script": r"script2.py"
    },
    "daily_Qs_task_performance": {
    # qliksense task scheduler load performance
        "enabled": True,
        "interval": "daily at 23:58",
        "script": r"D:\OneDrive - 8088\Scripts\Python\ScheduledTasks\tasks\Qs_task_performance.pyw"
    },
    "weekly_Wed_keepalive": {
    # admin keep alive
        "enabled": True,
        "interval": "every Wednesday at 17:00",
        "script": r"D:\OneDrive - 8088\Scripts\Python\ScheduledTasks\tasks\keepalive.pyw"
    },
    "weekly_Fri_dms": {
    # dead man's switch
        "enabled": True,
        "interval": "every Friday at 17:00",
        "script": r"D:\OneDrive - 8088\Scripts\Python\ScheduledTasks\tasks\dms.py"
    }
}

def job(task):
    script_name = tasks[task]["script"]
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Job {task} started, running script {script_name}.")
    with open(log, "a") as f:
        f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Job {task} started, running script {script_name}.\n")
    try:
        subprocess.run(["C:\\Python\\python.exe", script_name], check=True)
    except subprocess.CalledProcessError as e:
        error_msg = str(e)
        print(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Job {task} failed with error: {error_msg}")
        with open(log, "a") as f:
            f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Job {task} failed with error: {error_msg}\n")

def check_tasks():
    for task in tasks:
        if tasks[task]["enabled"]:
            if "minutes" in tasks[task]["interval"]:
                interval = int(tasks[task]["interval"].split()[0])
                schedule.every(interval).minutes.do(job, task)
            elif "hourly" in tasks[task]["interval"]:
                schedule.every().hour.at(":10").do(job, task)
            elif "daily" in tasks[task]["interval"]:
                time_str = tasks[task]["interval"].split()[2]
                schedule.every().day.at(time_str).do(job, task)
            elif "Wednesday" in tasks[task]["interval"]:
                time_str = tasks[task]["interval"].split()[3]
                schedule.every().wednesday.at(time_str).do(job, task)
            elif "Friday" in tasks[task]["interval"]:
                time_str = tasks[task]["interval"].split()[3]
                schedule.every().friday.at(time_str).do(job, task)
            # tmd 居然不支持按月触发，啥也不是 😶
            # elif "month" in tasks[task]["interval"]:
            #     time_str = tasks[task]["interval"].split()[3]
            #     schedule.every().month.at(time_str).do(job, task)

# schedule.every().seconds # 每秒运行一次
# schedule.every(2).seconds # 每2秒运行一次
# schedule.every(1).to(5).seconds # 每1-5秒运行一次
# schedule.every().minutes # 每分钟运行一次
# schedule.every().hour # 每小时运行一次
# schedule.every().day # 每天运行一次如果后面没有at表示每天当前时间执行一次
# schedule.every().day.at("00:00"). # 每天凌晨运行一次
# schedule.every().week # 每周凌晨运行一次
# schedule.every().wednesday.at("00:00") # 每周三凌晨运行一次
            
check_tasks()
while True:
    schedule.run_pending()
    time.sleep(300)
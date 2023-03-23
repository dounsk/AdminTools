import time
import schedule
import subprocess
log = "Python\ScheduledTasks\ScheduledTaskExecution.Log"
tasks = {
    "task1": {
        "enabled": True,
        "interval": "10 minutes",
        "script": "script1.py"
    },
    "task2": {
        "enabled": True,
        "interval": "hourly at 10 minutes past the hour",
        "script": "script2.py"
    },
    "task3": {
        "enabled": True,
        "interval": "daily at 01:00",
        "script": "script3.py"
    },
    "task4": {
        "enabled": True,
        "interval": "every Wednesday at 10:30",
        "script": "script4.py"
    },
    "task5": {
        "enabled": True,
        "interval": "every month on the 15th at 15:00",
        "script": "script5.py"
    }
}

def job(task):
    script_name = tasks[task]["script"]
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Job {task} started, running script {script_name}.")
    with open(log, "a") as f:
        f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}] Job {task} started, running script {script_name}.\n")
    try:
        subprocess.run(["python", script_name], check=True)
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
            elif "month" in tasks[task]["interval"]:
                time_str = tasks[task]["interval"].split()[3]
                schedule.every().month.at(time_str).do(job, task)

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
    time.sleep(1)
import time
import logging
import schedule

# 设置日志格式
logging.basicConfig(filename='Python\ScheduledTasks\ScheduledTaskExecution.Log', level=logging.INFO, format='%(asctime)s   %(levelname)s   %(message)s')
# 定义任务1
def task1():
    import os
    os.system('Python\ScheduledTasks\tasks\Qs_task_performance.pyw')
    logging.info('Task 1 executed')
# 定义任务2
def task2():
    import os
    os.system('Python\\temp\\test123.py')
    logging.info('Task 2 executed')
# 预设任务是否启动，启动时间
tasks = {
    'task1': {'enabled': True, 'start_time': '00:01'},
    'task2': {'enabled': False, 'start_time': '14:00'},
}
# 设置计划任务检查频次
schedule.every().hour.at(':01').do(lambda: check_and_run(tasks))
    # schedule.every().seconds # 每秒运行一次
    # schedule.every(2).seconds # 每2秒运行一次
    # schedule.every(1).to(5).seconds # 每1-5秒运行一次
    # schedule.every().minutes # 每分钟运行一次
    # schedule.every().hour # 每小时运行一次
    # schedule.every().day # 每天运行一次如果后面没有at表示每天当前时间执行一次
    # schedule.every().day.at("00:00"). # 每天凌晨运行一次
    # schedule.every().week # 每周凌晨运行一次
    # schedule.every().wednesday.at("00:00") # 每周三凌晨运行一次

# 检查是否需要运行任务
def check_and_run(tasks):
    for task_name, task_settings in tasks.items():
        if task_settings['enabled'] and time.strftime('%H:%M') == task_settings['start_time']:
            globals()[task_name]()
        else:
            logging.info(f'{task_name} was not executed')
            
def check_and_run(tasks):
    for task, config in tasks.items():
        if config['enabled']:
            start_time = config['start_time']
            # Tasks - [weekly]
            if start_time.startswith('Friday'):
                schedule.every().friday.at(start_time.split()[1]).do(eval(task))
            # Tasks - [monthly]
            elif start_time.startswith('15'):
                schedule.every().month.at(start_time.split()[1]).do(eval(task))
            # Tasks - [daily]
            else:
                schedule.every().day.at(start_time).do(eval(task))
            logging.info(f'{task} scheduled to start at {start_time}')

    # 每天晚上给跑了一天的驴驴子休息一小时 😊
    # if time.strftime('%H:%M') == '22:22':
    #     logging.info('Task manager stopped')
    #     exit()
# 循环执行任务
while True:
    schedule.run_pending()
    time.sleep(1)
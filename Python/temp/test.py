import os
import time
import schedule
import logging
import datetime
logging.basicConfig(filename='Python\ScheduledTasks\ScheduledTaskExecution.Log', level=logging.INFO)
# Define task1
def task1():
    os.system('Python\\temp\\test.py')
    logging.info('Task 1 executed')
# Define task2
def task2():
    os.system('Python\\temp\\test123.py')
    logging.info('Task 2 executed')
# Define weekly task3 to run on Fridays
def task3():
    os.system('Python\\temp\\123.py')
    logging.info('Task 3 executed')
# Define monthly task4 to run on the 15th of every month
def task4():
    os.system('Python\\temp\\monthly_script.py')
    logging.info('Task 4 executed')
# Set tasks to be enabled and start times
tasks = {
    'task1': {'enabled': True, 'start_time': '10:30'},
    'task2': {'enabled': False, 'start_time': '14:00'},
    'task3': {'enabled': True, 'start_time': 'Friday 10:00'},
    'task4': {'enabled': True, 'start_time': '15 10:00'},
}
# Check and run tasks
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
        else:
            logging.info(f'{task} was not executed')


check_and_run(tasks)
# Run scheduled tasks
while True:
    schedule.run_pending()
    time.sleep(1)
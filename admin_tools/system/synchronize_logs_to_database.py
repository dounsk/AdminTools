# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 4/15/2024 3:25 PM Monday
Project      : guard_filter_output_data.py
FilePath     : scripts/system/synchronize_logs_to_database
Description  :
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import hashlib
import os
import re
import psycopg2
from datetime import datetime, timedelta
from config.config import LOGS_DB_CONFIG
import shutil


class LogToDatabase:
    def __init__(self, days_to_scan=30):
        self.start_date = datetime.now() - timedelta(days=days_to_scan)
        self.logs_directory = '\logs'
        self.log_pattern = r"(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \[(\w+)\] \[(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\] \[(.*?)\] (.*), (\w+)"
        self.conn = psycopg2.connect(**LOGS_DB_CONFIG)
        self.cursor = self.conn.cursor()

    def parse_log_line(self, line):
        match = re.match(self.log_pattern, line)
        if match:
            asctime, levelname, client, username, message, method = match.groups()
            asctime = datetime.strptime(asctime, "%Y-%m-%d %H:%M:%S")
            return asctime, levelname, client, username, message, method
        return None

    def process_logs(self):
        for filename in os.listdir(self.logs_directory):
            if filename.endswith(".log"):
                file_date_str = re.search(r'\d{8}', filename)
                if file_date_str:
                    file_date = datetime.strptime(file_date_str.group(), "%Y%m%d")
                    if self.start_date <= file_date <= datetime.now():
                        print(f"Synchronize logs, processing file: {filename}")
                        with open(os.path.join(self.logs_directory, filename), "r") as log_file:
                            for line in log_file:
                                parsed_line = self.parse_log_line(line)
                                if parsed_line:
                                    asctime, levelname, client, username, message, method = parsed_line
                                    message = message.replace('', '')
                                    hasher = hashlib.sha1()
                                    hasher.update(
                                        f"{asctime}{levelname}{client}{username}{message}{method}".encode(
                                            'utf-8'))
                                    unique_id = hasher.hexdigest()

                                    # Check if the unique_id already exists
                                    self.cursor.execute("SELECT COUNT(*) FROM p404_event_echo WHERE id = %s",
                                                        (unique_id,))
                                    count = self.cursor.fetchone()[0]

                                    # If the unique_id does not exist, insert
                                    if count == 0:
                                        self.cursor.execute(
                                            "INSERT INTO p404_event_echo (id, asctime, levelname, client, username, message, method) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                                            (unique_id, asctime, levelname, client, username, message, method)
                                        )
                                        self.conn.commit()
                                        # print(
                                        #     f"Affected rows: {self.cursor.rowcount}, Inserted log entry: {unique_id}, {asctime}")
                                    else:
                                        # Skipped existing log entry
                                        pass

    def close(self):
        self.cursor.close()
        self.conn.close()


def archive_log_files():
    logs_directory = '\logs'
    backup_directory = '\logs\BAK'
    today = datetime.now().date()

    if not os.path.exists(backup_directory):
        os.makedirs(backup_directory)

    for filename in os.listdir(logs_directory):
        file_path = os.path.join(logs_directory, filename)
        if os.path.isfile(file_path):
            file_date = datetime.fromtimestamp(os.path.getmtime(file_path)).date()
            if file_date < today:
                shutil.move(file_path, os.path.join(backup_directory, filename))


def synchronize_logs_to_database():
    log_to_db = LogToDatabase()
    log_to_db.process_logs()
    log_to_db.close()
    # 归档日志文件
    archive_log_files()


if __name__ == "__main__":
    synchronize_logs_to_database()

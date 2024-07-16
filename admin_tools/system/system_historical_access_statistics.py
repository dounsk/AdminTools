# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 3/20/2024 3:52 PM Wednesday
Project      : config.py
FilePath     : test/access_logs
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import csv
from config.config import LOGS_DB_CONFIG
from collections import defaultdict
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import matplotlib.font_manager as font_manager
import psycopg2


def fetch_data_from_db(database_config):
    query = '''
    SELECT
        DATE(asctime) AS log_date,
        COUNT(id) AS log_entries,
        COUNT(DISTINCT client) AS unique_clients
    FROM
        p404_event_echo
    GROUP BY
        log_date
    ORDER BY
        log_date;
    '''

    with psycopg2.connect(**database_config) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            results = cur.fetchall()

    return results


def process_db_data(data, clients, ip_requests, one_month_ago, today):
    for log_date, log_entries, unique_clients in data:
        log_date = datetime.combine(log_date, datetime.min.time())
        if one_month_ago <= log_date <= today:
            clients[log_date] = unique_clients
            ip_requests[log_date] = log_entries


def save_logs_to_csv(clients, ip_requests):
    with open('./doc/system_statistics_visits.csv', 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['Date', 'UniqueClient', 'RequestCount'])
        for date in clients.keys():
            csv_writer.writerow(
                [date.strftime('%Y-%m-%d'), clients[date], ip_requests[date]])


def plot_line_chart(clients, ip_requests):
    dates = list(clients.keys())
    unique_clients = [clients[date] for date in dates]
    request_counts = [ip_requests[date] for date in dates]
    fig, ax = plt.subplots(figsize=(16, 4))
    ax.plot(dates, unique_clients, marker='o', label='Unique Clients', linewidth=2, linestyle='--',
            solid_capstyle='round')
    ax.plot(dates, request_counts, marker='x', label='Request Counts', linewidth=3, linestyle='-',
            solid_capstyle='round')

    # 自定义字体
    prop = font_manager.FontProperties(fname='./doc/ttf/SpecialElite.ttf', size=11)

    ax.set_xlabel('Date', fontproperties=prop)
    ax.set_ylabel('Count', fontproperties=prop)
    ax.set_title('Access History', fontproperties=prop)

    ax.legend()
    ax.grid(True)

    # Format date axis to show monthly dates
    ax.xaxis.set_major_locator(mdates.MonthLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%d %b %Y'))
    plt.setp(ax.get_xticklabels(), rotation=30)
    plt.setp(ax.get_xticklabels(), fontproperties=prop)
    plt.setp(ax.get_yticklabels(), fontproperties=prop)

    # Hide the box
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(True)
    ax.spines['left'].set_visible(True)

    # Remove horizontal tick marks
    ax.tick_params(axis='both', which='both', width=0)

    plt.tight_layout()
    path = './doc/shared_images/users_access_history.png'
    plt.savefig(path)
    plt.close()
    return path


def historical_access_status(days):
    clients = defaultdict(int)
    ip_requests = defaultdict(int)
    today = datetime.now()
    one_month_ago = today - timedelta(days=days)

    data = fetch_data_from_db(LOGS_DB_CONFIG)
    process_db_data(data, clients, ip_requests, one_month_ago, today)

    save_logs_to_csv(clients, ip_requests)
    image_path = plot_line_chart(clients, ip_requests)
    return image_path


if __name__ == '__main__':
    historical_access_status(9)

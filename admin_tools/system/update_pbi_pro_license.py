# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/8/20 下午2:54 星期二
Project      : AdminTools
FilePath     : admin_tools/system/update_pbi_pro_license
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""

import psycopg2
import psycopg2.extras
import requests
from datetime import datetime
import csv



def save_members_to_csv(members_data):
    with open(save_file_path, mode='w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['environment', 'mail_address', 'display_name', 'job_title', 'office_location', 'group_name',
                      'last_update_time']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for member in members_data:
            writer.writerow({
                'environment': member[0],
                'mail_address': member[1],
                'display_name': member[2],
                'job_title': member[3],
                'office_location': member[4],
                'group_name': member[5],
                'last_update_time': member[6],
            })


# 从数据库中获取已经存在的邮件地址
def get_existing_mail_addresses():
    conn = psycopg2.connect(**POWERBI_LOGS_DB_CONFIG)
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT mail_address FROM pbi_pro_license WHERE email_group_name = 'powerbi-pro-assign'")
        existing_mail_addresses = {row[0] for row in cursor.fetchall()}
    except psycopg2.Error as e:
        print(" psycopg2.Error", e)
        existing_mail_addresses = set()
    finally:
        cursor.close()
        conn.close()
    return existing_mail_addresses


# 仅当邮件地址不在已经存在的邮件名单中时，才添加
def read_csv_data(file_path, existing_mail_addresses):
    data = []
    with open(file_path, newline='', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['mail_address'] not in existing_mail_addresses:
                data.append((
                    row['environment'],
                    row['display_name'],
                    row['mail_address'],
                    '',  # job_title
                    row['office_location'],
                    'From SharePoint',  # email_group_name
                    row['last_update_time']
                ))
    return data


def sql_etl(sql_values):
    sql_statement = f"insert into pbi_pro_license (environment, mail_address, display_name, job_title, office_location, email_group_name, last_update_time) VALUES %s;"
    conn = psycopg2.connect(**POWERBI_LOGS_DB_CONFIG)
    cursor = conn.cursor()
    try:
        psycopg2.extras.execute_values(cursor, sql_statement, sql_values)
        conn.commit()
    except psycopg2.Error as e:
        print(" psycopg2.Error", e)
        conn.rollback()
    finally:
        cursor.close()
        conn.close()


def truncate_table():
    conn = psycopg2.connect(**POWERBI_LOGS_DB_CONFIG)
    cursor = conn.cursor()
    try:
        cursor.execute("TRUNCATE TABLE public.pbi_pro_license;")
        conn.commit()
    except psycopg2.Error as e:
        print(" psycopg2.Error", e)
        conn.rollback()
    finally:
        cursor.close()
        conn.close()


def update_email_group_members():
    all_members = []
    last_update_time = datetime.now()
    status_info = "OK"
    remarks_info = ""

    try:
        get_token_url = "https://graph.microsoft.com/beta/roleManagement/directory/estimateAccess"

        headers = {"Authorization": "Bearer " + str(AccessToken(get_token_url).get()),
                   "Content-Type": "application/json"}

        for group in groups:
            group_id = group["group_id"]
            group_name = group["group_name"]
            environment = group["environment"]
            idmc_email_api = f"https://graph.microsoft.com/v1.0/groups/{group_id}/members"

            members = []
            url = idmc_email_api
            while url:
                response = requests.get(url, headers=headers)
                if response.status_code != 200:
                    status_info = "Error"
                    remarks_info = f"status_code {response.status_code}, content {response.content}"
                    return
                data = response.json()
                members.extend(data.get('value', []))
                url = data.get('@odata.nextLink')  # 获取下一页的URL

            members_with_group_info = [
                (
                    environment,
                    member.get('mail'),
                    member.get('displayName'),
                    member.get('jobTitle'),
                    member.get('officeLocation'),
                    group_name,
                    last_update_time,
                )
                for member in members]

            all_members.extend(members_with_group_info)

        members_count = len(all_members)
        if members_count > 0:
            # 保存数据到本地 CSV 文件
            save_members_to_csv(all_members)
            # 清空表的数据
            truncate_table()
            # 插入数据库
            sql_etl(all_members)
            remarks_info = f"{members_count} members update to db"
        else:
            status_info = "Error"
            remarks_info = f"There was no success getting mailing group members, {members_count} members"
    except Exception as e:
        status_info = "Error"
        remarks_info = str(e)
    finally:
        active_script_check(f"[SmartETL] Update pbi_pro_license", last_update_time, status_info,
                            remarks_info)


def update_pbi_pro_license():
    # 更新邮件组成员
    update_email_group_members()

    # 增加更新ROW原有用户名单
    existing_mail_addresses = get_existing_mail_addresses()  # 获取邮件组新添加的用户
    csv_data = read_csv_data(csv_file_path, existing_mail_addresses)  # 获取 sharepoint row 用户名单
    sql_etl(csv_data)  # 更新 ROW用户名单


if __name__ == '__main__':
    update_pbi_pro_license()

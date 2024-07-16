# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/7/16 上午10:13 星期二
Project      : AdminTools
FilePath     : admin_tools/utils/sql_execution
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import psycopg2


# noinspection DuplicatedCode
def sql_execution(sql_statement, config):
    connection = psycopg2.connect(**config)
    cursor = connection.cursor()
    try:
        cursor.execute(sql_statement)
        connection.commit()
        result = cursor.fetchall()
        return result
    except psycopg2.Error as e:
        print(f">> ETL return error: ", e)
        connection.rollback()
    finally:
        connection.close()

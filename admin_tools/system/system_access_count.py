# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 1/30/2024 11:39 AM Tuesday
Project      : fastApiProject
FilePath     : scripts/log_api_access_statistics
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
from config.config import *
from admin_tools.utils.sql_execution import sql_execution


def log_statistics():
    # Execute SQL queries to get the required data
    total_lines_query = "SELECT COUNT(id) FROM p404_event_echo"
    total_lines_result = sql_execution(total_lines_query, LOGS_DB_CONFIG)
    total_lines = total_lines_result[0][0]

    unique_clients_query = "SELECT COUNT(DISTINCT (client)) FROM p404_event_echo"
    unique_clients_result = sql_execution(unique_clients_query, LOGS_DB_CONFIG)
    users = unique_clients_result[0][0]

    requests = f"{total_lines / 1000:.2f}k"
    return users, requests


def api_request_count():
    # Execute SQL queries to get the required data
    total_lines_query = "SELECT COUNT(id) FROM p404_event_echo"
    total_lines_result = sql_execution(total_lines_query, LOGS_DB_CONFIG)
    total_lines = total_lines_result[0][0]

    return total_lines


def resolved_user_tickets():
    # Execute SQL queries to get the required data
    total_lines_query = "select count(distinct(incidentid)) from v_dim_itsm_ticket"
    result = sql_execution(total_lines_query, LOGS_DB_CONFIG)
    total_tickets = result[0][0]

    return total_tickets


def count_helped_users_who_helped():
    # Execute SQL queries to get the required data
    total_lines_query = """
    SELECT
      (SELECT COUNT(DISTINCT client) FROM p404_event_echo) +
      (SELECT COUNT(DISTINCT username) FROM p404_event_echo) AS total_count;
"""
    result = sql_execution(total_lines_query, LOGS_DB_CONFIG)
    total_tickets = result[0][0]

    return total_tickets


if __name__ == "__main__":
    print(log_statistics())

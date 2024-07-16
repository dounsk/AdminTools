# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 6/25/2024 1:56 PM Tuesday
Project      : Project-404
FilePath     : scripts/system/p404_active_script
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import time
import psycopg2
from datetime import datetime
from config.config import *
from pydantic import BaseModel


class ActiveCheck(BaseModel):
    script_name: str
    triggered: datetime
    status: str
    remarks: str


def exe_active_script_check(script_name, triggered, status, remarks):
    last_updated = datetime.now()
    execution_duration = (datetime.now() - triggered).total_seconds()

    sql = """
    INSERT INTO public.p404_active_script (script_name, triggered, status, execution_duration, remarks, last_updated)
    VALUES (%s, %s, %s, %s, %s, %s);
    """

    connection = psycopg2.connect(**LOGS_DB_CONFIG)

    try:
        with connection.cursor() as cursor:
            cursor.execute(sql, (script_name, triggered, status, execution_duration, remarks, last_updated))
        connection.commit()
    except Exception as e:
        print(f"Exception PG SQL Insert Error: {e}")
    finally:
        connection.close()


if __name__ == "__main__":
    triggered = datetime.now()
    time.sleep(2)
    exe_active_script_check("Sample Script", triggered, "Success", "Take it easy.")

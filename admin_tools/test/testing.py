# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 7/17/2024 2:26 PM Wednesday
Project      : Project-404
FilePath     : scripts/database/synchronize_database_tables
Description  :
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import psycopg2
import psycopg2.extras
from config.config import *


def synchronize_apps(source_conn_info, target_conn_info):
    try:
        source_conn = psycopg2.connect(**source_conn_info)
        source_cur = source_conn.cursor()

        target_conn = psycopg2.connect(**target_conn_info)
        target_cur = target_conn.cursor()
        target_table_name = "qlik_sense_apps"

        create_table_query = f"""
        CREATE TABLE IF NOT EXISTS {target_table_name} (
        "ID"                    uuid                                                                 not null
            primary key,
        "Name"                  varchar(255)                                                         not null,
        "AppId"                 varchar(500),
        "PublishTime"           timestamp                                                            not null,
        "Published"             boolean                                                              not null,
        "Description"           varchar(512),
        "LastReloadTime"        timestamp                                                            not null,
        "Thumbnail"             varchar(512),
        "CreatedDate"           timestamp                                                            not null,
        "ModifiedDate"          timestamp                                                            not null,
        "ModifiedByUserName"    text                                                                 not null,
        "Owner_ID"              uuid,
        "Stream_ID"             uuid
    );
        """
        target_cur.execute(create_table_query)
        target_conn.commit()

        # Copy the data from the source to the target database
        source_cur.execute(
            f'select "ID", "Name", "AppId", "PublishTime", "Published", "Description", "LastReloadTime", "Thumbnail", "CreatedDate", "ModifiedDate", "ModifiedByUserName", "Owner_ID", "Stream_ID" from public."Apps"')
        data = source_cur.fetchall()
        if data:
            target_cur.execute(f"TRUNCATE TABLE {target_table_name};")

            insert_query = f"""
            insert into {target_table_name} ("ID", "Name", "AppId", "PublishTime", "Published", "Description", "LastReloadTime", "Thumbnail", "CreatedDate", "ModifiedDate", "ModifiedByUserName", "Owner_ID", "Stream_ID")            
            values %s;
            """
            psycopg2.extras.execute_values(target_cur, insert_query, data)
            target_conn.commit()
        source_cur.close()
        source_conn.close()
        target_cur.close()
        target_conn.close()

    except Exception as e:
        print(f"Error: {e}")


def synchronize_streams(source_conn_info, target_conn_info):
    try:
        source_conn = psycopg2.connect(**source_conn_info)
        source_cur = source_conn.cursor()

        target_conn = psycopg2.connect(**target_conn_info)
        target_cur = target_conn.cursor()
        target_table_name = "qlik_sense_streams"

        create_table_query = f"""
        CREATE TABLE IF NOT EXISTS {target_table_name} (
        "ID"                 uuid         not null
            primary key,
        "Name"               varchar(200) not null,
        "CreatedDate"        timestamp not null,
        "ModifiedDate"       timestamp not null,
        "ModifiedByUserName" text not null,
        "Owner_ID"           uuid
    );
        """
        target_cur.execute(create_table_query)
        target_conn.commit()

        # Copy the data from the source to the target database
        source_cur.execute(
            f'select "ID", "Name", "CreatedDate", "ModifiedDate", "ModifiedByUserName", "Owner_ID" from public."Streams"')
        data = source_cur.fetchall()
        if data:
            target_cur.execute(f"TRUNCATE TABLE {target_table_name};")

            insert_query = f"""
            insert into {target_table_name} ("ID", "Name", "CreatedDate", "ModifiedDate", "ModifiedByUserName", "Owner_ID")            
            values %s;
            """
            psycopg2.extras.execute_values(target_cur, insert_query, data)
            target_conn.commit()
        source_cur.close()
        source_conn.close()
        target_cur.close()
        target_conn.close()

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    pass
    # synchronize_apps(QLIKSENSE_PRD_DB_CONFIG, POWERBI_LOGS_DB_CONFIG)
    # synchronize_streams(QLIKSENSE_PRD_DB_CONFIG, POWERBI_LOGS_DB_CONFIG)

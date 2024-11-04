# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/10/28 下午3:41 星期一
Project      : AdminTools
FilePath     : admin_tools/api_testing/pbi_lineage
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import re

query_statements = """
{
    "status": "success",
    "data": "let{[Name=magellanedw,Kind=Database]}[Data],  from magellanedw.dwd_hr.lenovo_employee ) from magellanedw.dwd_srv.prc_svc_billing_plan 
"""

patterns = [
    r'(FROM|from)\s+(\w+)\.(\w+)\.(\w+)',  # 匹配 FROM schema.table.column
    r'(FROM|from)\s+(\w+)\.(\w+)',
    r'(FROM|from)\s+`([^`]+)`\.`([^`]+)`',
    r'(FROM|from)\s+`?([\w]+)`?\.`?([\w]+)`?(?=\W)',
    r"(FROM|from)\s+''\s*\.\s*''\s*([^']+)\s*\.\s*([^']+)",
    r'(FROM|from)\s+\[([^\]]+)\]\.\[([^\]]+)\]',
]
# 从xml文件中获取查询语句,query_statements 查询时应该包含连接的一部分
# query_statements = analyze_data_sources(workspaceid, datasetid, datasource_host)
# 初始化一个空列表用于存储数据源模式和数据表的组合
schema_table_pairs = []

for pattern in patterns:
    schema_table_pattern = re.compile(pattern, re.IGNORECASE)
    schema_table_matches = schema_table_pattern.findall(query_statements)

    for match in schema_table_matches:
        if pattern == patterns[0]:
            schema_table_pairs.append((match[2], match[3]))
        else:
            if "magellanedw" not in match[1]:  # 如果匹配到 magellanedw，跳过
                schema_table_pairs.append((match[1], match[2]))

if not schema_table_pairs:
    if len(query_statements) == 0:
        # 如果xml为空
        schema_table_pairs.append(('# NullQueryDefinition', '# NullQueryDefinition'))
    else:
        # 尝试从 query_statements 中提取 Database Schema 和 Table 名称
        schema_pattern = r'\[Name=(\w+),Kind=Schema\]'
        table_pattern = r'\[Name=(\w+),Kind=(Table|View)\]'

        schema_match = re.search(schema_pattern, query_statements)
        table_match = re.search(table_pattern, query_statements)

        if schema_match and table_match:
            schema_name = schema_match.group(1)
            table_name = table_match.group(1)
            schema_table_pairs.append((schema_name, table_name))
        else:
            schema_table_pairs.append(('# MissedIt', '# MissedIt'))  # 如果没有找到匹配项

print(schema_table_pairs)

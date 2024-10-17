# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 9/29/2024 4:09 PM Sunday
Project      : Guardrails
FilePath     : /analyze_api_response
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import csv
import json
from collections import defaultdict
import statistics


# 读取CSV文件
def read_csv(file_path):
    with open(file_path, newline='', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)
        data = [row for row in reader]
    return data


def calculate_average(data):
    total = sum(data)
    count = len(data)
    return total / count if count > 0 else 0


# 计算中位数、最大值、最小值
def calculate_stats(data):
    if not data:
        return 0, 0, 0, 0
    return round(calculate_average(data), 2), round(statistics.median(data), 2), round(min(data), 2), round(max(data),
                                                                                                            2)


# 分类数据并计算统计数据
def process_data(data):
    categories = defaultdict(lambda: defaultdict(list))

    for row in data:
        lang_mode = row['lang_mode']
        content_length = int(row['content_length'])
        api_response_time = float(row['api_response_time(ms)'])
        categories[lang_mode][content_length].append(api_response_time)

    results = {}
    for lang_mode, lengths in categories.items():
        results[lang_mode] = {}
        for content_length, response_times in lengths.items():
            mean, median, min_value, max_value = calculate_stats(response_times)
            results[lang_mode][content_length] = {
                "avg": f"{mean} ms",
                "median": f"{median} ms",
                "min": f"{min_value} ms",
                "max": f"{max_value} ms"
            }

    return results


def analyze_api_response_time(file_path):
    data = read_csv(file_path)
    results = process_data(data)
    return json.dumps(results, indent=2)


if __name__ == "__main__":
    file = "data/InnerMongolia_20240929_1.csv"
    json_output = analyze_api_response_time(file)
    print(json_output)

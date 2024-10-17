# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 9/19/2024 10:10 AM Thursday
Project      : Guardrails
FilePath     : /guardrails_performance_test
Description  : 用于 Guardrails 敏感防护接口测试,批量执行API请求测试
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import time
import requests
from datetime import datetime
import urllib3
import hashlib
from concurrent.futures import ThreadPoolExecutor
from json.decoder import JSONDecodeError
from tqdm import tqdm
from analyze_api_response import *
# from utils.lenovo_smtp import *
from collections import defaultdict

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def read_csv_input(file_path):
    content_inputs = []
    sensitive_categories = []
    # token_lengths = []
    lang_modes = []
    with open(file_path, 'r', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)
        # content_input 为必须字段
        if 'content_input' not in reader.fieldnames:
            print(f"Warning: 'content_input' column not found in {file_path}. Please check the CSV file.")
            return content_inputs, sensitive_categories

        for row in reader:
            content_inputs.append(row['content_input'])
            # 可选设置sensitive_categories，验证准确性
            sensitive_categories.append(row.get('sensitive_categories', '') if isinstance(row, dict) else '')
            # token_lengths.append(row.get('content_length', None))
            lang_modes.append(row.get('lang_mode', ''))

    return content_inputs, sensitive_categories, lang_modes


def send_request(content_input, url, request_timeout):
    if content_input is not None:
        headers = {
            "Content-Type": "application/json",
        }
        body = {
            "request_category_level1": [],
            "category_l3_filter": [],
            "content_input": f"{content_input}",
            "appid": "github-copilot123",
            "templateid": "github-copilot_001",
            "action_flag": "replace",
            "recognition_method": ""
        }
        json_data = json.dumps(body)
        start_time = time.time()
        try:
            response = requests.post(url, data=json_data, headers=headers, verify=False, timeout=request_timeout)
            status_code = response.status_code
            try:
                response_json = response.json()
            except JSONDecodeError as e:
                tqdm.write(
                    f"{datetime.now()} - Response error: {str(response.text)}")
                response_json = {'Response': response.text}
        except requests.exceptions.RequestException as e:
            tqdm.write(f"{datetime.now()} - Request error: {str(e)}")
            status_code = e
            response_json = {'RequestException': str(e)}
        end_time = time.time()

        start_time_str = datetime.fromtimestamp(start_time).strftime('%Y-%m-%d %H:%M:%S.%f')
        end_time_str = datetime.fromtimestamp(end_time).strftime('%Y-%m-%d %H:%M:%S.%f')
        response_time_ms = (end_time - start_time) * 1000
        response_time_str = f"{response_time_ms:.2f}"

        hash_object = hashlib.md5()
        hash_object.update(content_input.encode("utf-8-sig"))
        hash_result = hash_object.hexdigest()

        # 如下两个服务限制一分钟最多请求10次，超额请求服务就报错，小憩片刻
        if '30082' in url or '30083' in url:
            time.sleep(15)

        content_length = len(content_input)

        return {
            'hash_value': hash_result,
            'content_length': content_length,
            'send_time': start_time_str,
            'response_time': end_time_str,
            'api_response_time': response_time_str,
            'status_code': status_code,
            'response_json': response_json
        }


def write_results_to_csv(input_file, content_inputs, sensitive_categories, lang_modes, results):
    fieldnames = ['content_input', 'sensitive_categories', 'content_length', 'lang_mode', 'hash_value', 'send_time',
                  'response_time', 'api_response_time(ms)', 'status_code', 'request_url', 'response_json', 'remark']
    status_code_counts = defaultdict(int)
    with open(input_file, 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for content_input, sensitive_category, lang_mode, result in zip(content_inputs, sensitive_categories,
                                                                        lang_modes, results):
            row = {
                'content_input': content_input,
                'sensitive_categories': sensitive_category,
                'content_length': result['content_length'],
                'lang_mode': lang_mode,
                'hash_value': result['hash_value'],
                'send_time': result['send_time'],
                'response_time': result['response_time'],
                'api_response_time(ms)': result['api_response_time'],
                'status_code': result['status_code'],
                'request_url': url,
                'response_json': json.dumps(result['response_json']),
                'remark': remark_info
            }
            status_code_counts[result['status_code']] += 1
            writer.writerow(row)

        return status_code_counts


def main():
    logs_info = {}
    request_timeout = 25
    try:
        time_start = datetime.now()
        content_inputs, sensitive_categories, lang_modes = read_csv_input(example_data)

        with ThreadPoolExecutor(max_workers=concurrency) as executor:
            print(
                f">> {datetime.now()} - Starting testing with {concurrency} concurrent requests")
            results = list(
                tqdm(executor.map(lambda content_input: send_request(content_input, url, request_timeout),
                                  content_inputs), total=len(content_inputs), desc="Processing"))
        status_code_counts = write_results_to_csv(f"data/{save_as_file_name}", content_inputs,
                                                  sensitive_categories, lang_modes, results)
        time_end = datetime.now()
        total_running_time = round((time_end - time_start).total_seconds() * 1000, 2)

        print(
            f">> {datetime.now()} - Processing is completed and the results are saved to data/{save_as_file_name}")
        print(f"Total time spent: {total_running_time}ms")
        print("=-" * 25)
        logs_info["request_time"] = datetime.now().strftime("%a, %Y-%m-%d %H:%M:%S")
        logs_info["request_url"] = url
        logs_info["request_items_count"] = len(content_inputs)
        logs_info["request_concurrency"] = concurrency
        logs_info["request_completed_time"] = total_running_time
        logs_info["status_code_counts"] = dict(status_code_counts)

        analysis_results = analyze_api_response_time(f"data/{save_as_file_name}")
        logs_info["api_response_details"] = json.loads(analysis_results)

        # 将日志信息写入文件
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        log_file = save_as_file_name.replace('.csv', f'_{timestamp}.json')
        with open(f"logs/Log_{log_file}", 'w', encoding='utf-8') as f:
            f.write(json.dumps(logs_info, indent=2))

        # 发送邮件通知
        # send_email_with_test_results(logs_info, f"data/{save_as_file_name}")
    except Exception as e:
        print("> Run Error: ", e)


if __name__ == '__main__':
    # 指定不同环境的请求地址
    # url = 'http://10.122.33.50:30081/guard_service/guard_engine/privacy_protection'
    url = 'https://dev.safetyguard.lenovo.com:8001/guard_service/guard_engine/privacy_protection'  # DEV ENV
    # url = 'https://ai.ludp.lenovo.com/ics-nm/guard-service-row/guard_engine/privacy_protection'  # PRD ENV
    # url = 'https://ai.ludp.lenovo.com/ics-nm/guard-service-row/guard_engine/privacy_protection'  # InnerMongolia
    # url = 'https://aiverse-row.ludp.lenovo.com/ics-reston/guard-service-row/guard_engine/privacy_protection'  # Reston

    # 测试样本数据
    example_data = "Sensitive Data_zh.csv"
    # 执行的线程数
    concurrency = 1
    # 另存为其他文件名
    save_as_file_name = f"dev_safetyguard_20241014_({concurrency}).csv"

    # 测试数据备注字段预留信息
    remark_info = "n/a"

    # 开整
    main()

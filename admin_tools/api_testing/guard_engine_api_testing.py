import csv
import time
import requests
import datetime
import urllib3
import json
from concurrent.futures import ThreadPoolExecutor
from json.decoder import JSONDecodeError
from tqdm import tqdm

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

"""
批量执行API请求测试，结果保存到原文件
"""


def read_csv_input(file_path):
    content_inputs = []
    with open(file_path, 'r', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)

        if 'content_input' not in reader.fieldnames:
            print(f"Warning: 'content_input' column not found in {file_path}. Please check the CSV file.")
            return content_inputs

        for row in reader:
            content_inputs.append(row['content_input'])
    return content_inputs


def send_request(content_input, url, request_timeout):
    if content_input is None:
        pass
    else:
        headers = {
            "Content-Type": "application/json",
        }
        body = {
            "request_category_level1": [],
            "category_l3_filter": ['personal_name_zh',
                                   'personal_name_en',
                                   'email',
                                   'phone_fax',
                                   'mac',
                                   'imei',
                                   'itcode',
                                   'ipv4',
                                   'ipv6',
                                   'usci',
                                   'identity_card_prc',
                                   'credit_card_number',
                                   'debit_card_number',
                                   'passport',
                                   'pin',
                                   ],
            "content_input": f"{content_input}",
            "appid": "github-copilot",
            "templateid": "github-copilot_001",
            "action_flag": ""
        }
        json_data = json.dumps(body)
        start_time = time.time()
        try:
            response = requests.post(url, data=json_data, headers=headers, verify=False, timeout=request_timeout)
            status_code = response.status_code
            try:
                response_json = response.json()
            except JSONDecodeError as json_error:
                tqdm.write(
                    f"{datetime.datetime.now()} - JSONDecodeError: {json_error}, Response text: {str(response.text)}")
                response_json = {'JSONDecodeError': response.text}
        except requests.exceptions.RequestException as e:
            tqdm.write(f"{datetime.datetime.now()} - Request error: {str(e)}")
            status_code = e
            response_json = {'RequestException': str(e)}
        end_time = time.time()

        start_time_str = datetime.datetime.fromtimestamp(start_time).strftime('%Y-%m-%d %H:%M:%S.%f')
        end_time_str = datetime.datetime.fromtimestamp(end_time).strftime('%Y-%m-%d %H:%M:%S.%f')
        response_time = end_time - start_time
        response_time_str = str(datetime.timedelta(seconds=response_time))

        # 如下两个服务限制一分钟最多请求10次，超额请求服务就报错，小憩片刻
        if '30082' in url or '30083' in url:
            time.sleep(15)

        return {
            'send_time': start_time_str,
            'response_time': end_time_str,
            'api_response_time': response_time_str,
            'status_code': status_code,
            'response_json': response_json
        }


def write_results_to_csv(input_file, content_inputs, results):
    with open(input_file, 'r', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)
        fieldnames = reader.fieldnames

    with open(input_file, 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for content_input, result in zip(content_inputs, results):
            row = {
                'content_input': content_input,
                'send_time': result['send_time'],
                'response_time': result['response_time'],
                'api_response_time': result['api_response_time'],
                'status_code': result['status_code'],
                'response_json': json.dumps(result['response_json'])
            }
            writer.writerow(row)


if __name__ == '__main__':
    """
    30081：Transform + Identifier （for GitHub copilot ）
    http://10.122.33.50:30081/guard_service/guard_engine/privacy_protection
     
    30082：Prompt 分类+Identifier
    http://10.122.33.50:30082/guard_service/guard_engine/privacy_protection
     
    30083：Prompt 预判 + Transform + Identifier
    http://10.122.33.50:30083/guard_service/guard_engine/privacy_protection
    """
    # 指定不同环境的请求地址
    url = 'http://10.122.33.50:30081/guard_service/guard_engine/privacy_protection'  # TST ENV
    # url = 'https://dev.safetyguard.lenovo.com:8001/guard_service/guard_engine/privacy_protection'  # DEV ENV
    # url = 'https://ai.ludp.lenovo.com/ics-nm/guard-service/guard_engine/privacy_protection'  # PRD ENV

    # 执行的线程数
    concurrency = 10
    # 单次请求超时时间
    request_timeout = 360

    # 输入文件数组输入，可以指定，或者循环拆分的小文件，请指定小文件数量
    input_file = [f"github_copilot_proxy_datas/split_chunk_{i}.csv" for i in range(1, 160)]

    for file in input_file:
        content_inputs = read_csv_input(file)

        with ThreadPoolExecutor(max_workers=concurrency) as executor:
            print(f">> {datetime.datetime.now()} -  {file} starting stress test with {concurrency} concurrent requests")
            # 增加进度显示
            results = list(tqdm(executor.map(lambda content_input: send_request(content_input, url, request_timeout),
                                             content_inputs), total=len(content_inputs), desc="Processing"))
        # 输出结果
        write_results_to_csv(file, content_inputs, results)

        print(f"{datetime.datetime.now()} - Stress test completed. Results saved to {file}.")

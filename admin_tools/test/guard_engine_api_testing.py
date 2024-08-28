import csv
import time
import requests
import datetime
import urllib3
import json
from concurrent.futures import ThreadPoolExecutor

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def read_csv_input(file_path):
    content_inputs = []
    with open(file_path, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            content_inputs.append(row['content_input'])
    return content_inputs


def send_request(content_input, url, request_timeout):
    headers = {
        "Content-Type": "application/json",
    }
    body = {
        "request_category_level1": [],
        "category_l3_filter": [],
        "content_input": f"{content_input}",
        "appid": "guard-tst",
        "templateid": "",
        "action_flag": "mask"
    }
    json_data = json.dumps(body)
    start_time = time.time()
    try:
        response = requests.post(url, data=json_data, headers=headers, verify=False, timeout=request_timeout)
        status_code = response.status_code
        response_json = response.json()
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")
        status_code = e
        response_json = {}
    end_time = time.time()

    start_time_str = datetime.datetime.fromtimestamp(start_time).strftime('%Y-%m-%d %H:%M:%S.%f')
    end_time_str = datetime.datetime.fromtimestamp(end_time).strftime('%Y-%m-%d %H:%M:%S.%f')
    response_time = end_time - start_time
    response_time_str = str(datetime.timedelta(seconds=response_time))

    return {
        'send_time': start_time_str,
        'response_time': end_time_str,
        'api_response_time': response_time_str,
        'status_code': status_code,
        'response_json': response_json
    }


def write_results_to_csv(input_file, content_inputs, results):
    with open(input_file, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        fieldnames = reader.fieldnames

    with open(input_file, 'w', newline='', encoding='utf-8') as csvfile:
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
    url = 'http://10.122.33.50:30081/guard_service/guard_engine/privacy_protection'
    concurrency = 1
    input_file = 'stress_test_results.csv'
    request_timeout = 600

    content_inputs = read_csv_input(input_file)

    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        print(f"Starting stress test with {concurrency} concurrent requests...")
        results = list(
            executor.map(lambda content_input: send_request(content_input, url, request_timeout), content_inputs))

    write_results_to_csv(input_file, content_inputs, results)

    print(f"Stress test completed. Results saved to {input_file}.")

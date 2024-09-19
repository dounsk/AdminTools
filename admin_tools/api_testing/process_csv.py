import csv
import json

"""
我是谁？提取API返回结果response_json各项信息的小喽啰
我可以将response_json每个返回值提取，供大王查阅详情。大王有事情随时吩咐小的。
"""

# 定义要提取的字段
fields = [
    "key_word", "request_category_level1", "offset_start", "offset_end",
    "category_level1", "category_level2", "category_level3", "safety_level",
    "sensitivity", "check_type", "key_word_replace"
]


def main():
    with open(input_csv_file, 'r', encoding="utf-8-sig") as input_file, open(output_csv_file, 'w', newline='',
                                                                             encoding="utf-8-sig") as output_file:
        csv_reader = csv.DictReader(input_file)
        csv_writer = csv.DictWriter(output_file, fieldnames=fields)
        csv_writer.writeheader()

        for row in csv_reader:
            response_json = row.get('response_json', '')

            try:
                json_data = json.loads(response_json)
                data = json_data.get('data', [])

                for item in data:
                    # 检查是否包含所有所需字段
                    if all(field in item for field in fields):
                        csv_writer.writerow(item)

            except json.JSONDecodeError:
                # 如果response_json不是有效的JSON，跳过该行
                pass


if __name__ == "__main__":
    # 指定需要格式化response_json的文件
    input_csv_file = 'github_copilot_proxy_datas/merged_output_0826.csv'
    # 指定输出的文件地址
    output_csv_file = 'github_copilot_proxy_datas/response_json_output_0826.csv'
    # 执行提取
    main()

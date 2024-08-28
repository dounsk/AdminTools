import os
import csv
"""
拆分文件，正如我之前所说，单文件执行风险大，拆碎后执行嘎嘎好 b（￣▽￣）d　
"""

def split_csv_file(input_file, output_dir, chunk_size):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(input_file, 'r', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)
        headers = reader.fieldnames
        file_number = 1
        row_count = 0
        current_chunk = []

        for row in reader:
            current_chunk.append(row)
            row_count += 1

            if row_count == chunk_size:
                output_file = os.path.join(output_dir, f"split_chunk_{file_number}.csv")
                with open(output_file, 'w', newline='', encoding='utf-8-sig') as output_csv:
                    writer = csv.DictWriter(output_csv, fieldnames=headers)
                    writer.writeheader()
                    writer.writerows(current_chunk)
                current_chunk = []
                row_count = 0
                file_number += 1

        if current_chunk:
            output_file = os.path.join(output_dir, f"split_chunk_{file_number}.csv")
            with open(output_file, 'w', newline='', encoding='utf-8-sig') as output_csv:
                writer = csv.DictWriter(output_csv, fieldnames=headers)
                writer.writeheader()
                writer.writerows(current_chunk)


if __name__ == '__main__':
    input_file = 'github_copilot_proxy_datas/raw10k.csv'
    output_dir = 'github_copilot_proxy_datas'
    chunk_size = 100

    split_csv_file(input_file, output_dir, chunk_size)
    print(
        f"CSV file '{input_file}' has been split into chunks of {chunk_size} rows and saved in the '{output_dir}' directory.")

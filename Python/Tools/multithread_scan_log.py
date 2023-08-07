import os
import csv
import datetime
import threading

def scan_log_file(file_path, keywords, output_file):
    file_name = os.path.basename(file_path)
    file_size = os.path.getsize(file_path)
    file_creation_time = os.path.getctime(file_path)
    print('Checking ' + file_name)
    with open(file_path, 'r', encoding='utf-8-sig') as file:
        for line in file:
            for keyword in keywords:
                if keyword in line:
                    row_data = [str(datetime.datetime.fromtimestamp(file_creation_time)), file_name, file_path, file_size, keyword, line]
                    with open(output_file, 'a', newline='') as csv_file:
                        writer = csv.writer(csv_file)
                        writer.writerow(row_data)

def scan_logs_in_folder(folder_path, keywords, output_file):
    # 创建多线程
    threads = []
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                thread = threading.Thread(target=scan_log_file, args=(file_path, keywords, output_file))
                threads.append(thread)
                thread.start()
                thread.join()  # 在扫描完一个文件后就关闭这个文件

if __name__ == "__main__":
    timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    folder_path = r"\\PEKWPQLIK06\ScriptLogs\DEV\tst"
    output_file = r"D:\TstEnv\data\logs_scan_" + timestamp + ".csv"
    # --- 需要查找的关键字
    keywords = ['LIB', 'QVD', 'successfully']

    # 创建CSV文件并写入标题
    with open(output_file, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(['Log Creation Time', 'Log Name', 'Log Path', 'Log Size(kb)', 'Keyword', 'Logs'])
    scan_logs_in_folder(folder_path, keywords, output_file)
    print("扫描完成，结果已输出到", output_file)
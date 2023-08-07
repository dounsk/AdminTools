import os
import uuid
import random
import string
import threading
def create_log_file(folder_path):
    # 生成随机的文件名
    file_name = str(uuid.uuid4()) + ".log"
    file_path = os.path.join(folder_path, file_name)
    # 生成随机的文件内容
    content = ''.join(random.choices(string.ascii_letters + string.digits, k=100))
    # 写入文件
    with open(file_path, "w") as file:
        file.write(content)
def create_log_files_in_folder(folder_path, num_files):
    # 创建多线程
    threads = []
    for _ in range(num_files):
        thread = threading.Thread(target=create_log_file, args=(folder_path,))
        threads.append(thread)
        thread.start()
    # 等待所有线程结束
    for thread in threads:
        thread.join()
if __name__ == "__main__":
    folder_path = r"D:\TstEnv\data\tst"
    num_files = 10000  # 需要生成的文件数量
    create_log_files_in_folder(folder_path, num_files)
    print("文件生成完成")
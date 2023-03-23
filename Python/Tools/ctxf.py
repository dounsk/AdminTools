import os
import csv
import datetime

# ^ You need to modify the settings first ------------------------------------------------------------------------------------------
# 预设扫描节点，需要将子节点目录 'C:\ProgramData\Qlik\Sense\Engine\CrashDumps' 设置共享访问并添加本机访问权限
nodes = [
    #[PRD]
    "SYPQLIKSENSE15","SYPQLIKSENSE18","SYPQLIKSENSE11","SYPQLIKSENSE12","SYPQLIKSENSE13",
    #[DEV]
    "PEKWPQLIK06","PEKWPQLIK01","PEKWPQLIK03","PEKWPQLIK04","SYPQLIKSENSE09"
    ]
# 预设扫描导出的字段名
fieldnames = ['Nodes', 'DateTime', 'Integrity', 'NbrActiveRequests', 'Username', 'UniqueId', 'DocName', 'Integrity',
    'OrderNumber', 'TargetPtr', 'TargetHandle', 'Exception', 'Started','Finished', 'Method', 'SubObjectPath', 'IsInValidate'
    ]
# 设置扫描文件导出目录
export_directory = "C:\\Users\\douns\\Downloads\\"
# ^ --------------------------------------------------------------------------------------------------------------------------------

def scan_CTXF(file_path, node, fieldnames):
    # 打印文件检查进程
    print('[Checking] ' + file_path)
    # 获取文件创建时间
    created_time = os.path.getctime(file_path)
    # 将时间转换为指定格式
    formatted_time = datetime.datetime.fromtimestamp(created_time).strftime('%Y-%m-%d %H:%M:%S')
    # 打开目标文件进行读取每行内容
    with open(file_path, 'r') as f:
        lines = [line.strip() for line in f.readlines()]
    # 创建一个空字典用于存储name-value
    data = {}
    # 存储扫描 node 信息
    data['Nodes'] = node
    # 存储文件创建时间
    data['DateTime'] = formatted_time
    # 遍历每一行并解析出name-value
    for line in lines:
        # 如果当前行是一个新的[Section]，则跳过
        if line.startswith('['):
            continue
        # 如果是UserName则单独处理domain/userid, 例如：'Username=UserDirectory=LENOVOAD; UserId=mcambounet'
        elif line.startswith('Username'):
            # 用等号分割字符串
            parts = line.split('=')
            # 如果分割后值不为空，则替换为指定用户信息domain/userid
            if len(parts) > 2:
                name = parts[0].strip()
                value = parts[2].strip().replace('; UserId', '/') + parts[3].strip()
                # 将name-value对存储到字典中
                data[name] = value
        else:
            # 用等号分割字符串
            parts = line.split('=')
            # 分别取出name和value，并去除首尾空格
            name = parts[0].strip()
            value = parts[1].strip()
            # 将name-value对存储到字典中
            if name in fieldnames:
                data[name] = value
    return data


if __name__ == '__main__':
    suffix      = datetime.datetime.now().strftime('%Y%m%d%H%M')
    export_file = export_directory + 'EngineCrashDumps_CTXFlogs_' + suffix +'.csv'
    # 打开CSV文件进行写操作
    with open(export_file, 'w', newline='') as f:
        # 写入表头
        writer = csv.DictWriter(f, fieldnames)
        writer.writeheader()
        for node in nodes:
            # 循环扫描每个子节点
            files_dir = "//" + node +"//CrashDumps//"
            # 遍历子节点 CrashDumps 目录中的所有文件
            for filename in os.listdir(files_dir):
                file_path = os.path.join(files_dir, filename)
                # 只处理指定格式文件
                if not filename.endswith('.ctxf'):
                    # print('[ignore] The file suffix is not included: ' + filename)
                    continue
                # 将数据写入CSV文件
                data = scan_CTXF(file_path, node, fieldnames)
                writer.writerow(data)
    print("\033[32m {}\033[00m".format('-- The log check has completed. --'))
    # 关闭csv文件
    f.close()
    # 打开文件导出目录
    os.startfile(export_directory)
#python 

增加文件存在性的判断，如果文件存在则读取表头并判断是否与fieldnames相同，如果相同则不添加表头，否则添加表头。修改写入数据的方式为追加模式，实现了增量存储的效果。

```python
import os
import csv
from datetime import datetime
export_directory = "//10.122.36.118//QlikOperations//QsTaskStatus//"
fieldnames = ['DateTime', 'Started_Number', 'Queued_Number', 'ExecutingNodeName']
suffix = datetime.now().strftime('%Y%m%d')
export_file = export_directory + 'QlikSense_TaskStatus_' + suffix +'.csv'
# 判断文件是否存在，如果存在则读取表头
if os.path.isfile(export_file):
    with open(export_file, 'r') as f:
        reader = csv.reader(f)
        headers = next(reader)
        if headers == fieldnames:
            add_header = False
        else:
            add_header = True
    f.close()
else:
    add_header = True
# 写入数据
with open(export_file, 'a', newline='') as f:
    writer = csv.DictWriter(f, fieldnames)
    if add_header:
        writer.writeheader()
    taskStatus()
f.close()
```


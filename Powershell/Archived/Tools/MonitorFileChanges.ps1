# make sure this points to a log file
$Path = '\\myserver\report2.txt'

Get-Content -Path $Path -Tail 0 -Wait |
ForEach-Object {
    "Detected $_"
}

#只要确保修改 $path 指向某个实际的日志文件。
#每当向文件附加文本（并且保存更改），ForEach-Object 循环都会执行脚本块并输出 “Detected “。
#通过这种方式，您可以方便地响应实际的改变。

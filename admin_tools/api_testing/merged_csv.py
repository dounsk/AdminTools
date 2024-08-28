"""
为啥要合并文件呢？
测试请求需要按要求写回原文件，但请求速度很慢，单文件请求大量数据容易导致异常
拆分小文件后分批请求，得到结果后执行本文件将小文件合并
"""


def mian():
    with open(output_file, "w", encoding="utf-8-sig") as outfile:
        # Write the header from the first file
        with open(input_files[0], "r", encoding="utf-8-sig") as infile:
            header = infile.readline()
            outfile.write(header)

        # Write the data from all files, skipping the header
        for file in input_files:
            with open(file, "r", encoding="utf-8-sig") as infile:
                infile.readline()  # Skip header
                for line in infile:
                    outfile.write(line)


if __name__ == "__main__":
    # 需要合并多少个文件？
    input_files = [f"github_copilot_proxy_datas/split_chunk_{i}.csv" for i in range(1, 66)]
    # 合并文件的输出
    output_file = "github_copilot_proxy_datas/merged_output_0826.csv"
    mian()

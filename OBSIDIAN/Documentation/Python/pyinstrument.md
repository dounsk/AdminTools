# 用户指南[](https://pyinstrument.readthedocs.io/en/latest/guide.html#user-guide "Permalink to this headline")

## 安装[](https://pyinstrument.readthedocs.io/en/latest/guide.html#installation "Permalink to this headline")

pip install pyinstrument

Pyinstrument 支持 Python 3.7+。

## 分析一个 Python 脚本[](https://pyinstrument.readthedocs.io/en/latest/guide.html#profile-a-python-script "Permalink to this headline")

直接从命令行调用 Pyinstrument。而不是写 ，键入 。您的脚本将运行为 正常，最后（或按时），Pyinstrument 将输出 彩色摘要显示大部分时间花费在哪里。`python script.py``pyinstrument script.py``^C`

以下是您可以使用的选项：

Usage: pyinstrument [options] scriptfile [arg] ...

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  --load-prev=ID        instead of running a script, load a previous report
  -m MODULE_NAME        run library module as a script, like 'python -m
                        module'
  --from-path           (POSIX only) instead of the working directory, look
                        for scriptfile in the PATH environment variable
  -o OUTFILE, --outfile=OUTFILE
                        save to <outfile>
  -r RENDERER, --renderer=RENDERER
                        how the report should be rendered. One of: 'text',
                        'html', 'json', 'speedscope', or python import path
                        to a renderer class
  -t, --timeline        render as a timeline - preserve ordering and don't
                        condense repeated calls
  --hide=EXPR           glob-style pattern matching the file paths whose
                        frames to hide. Defaults to '*/lib/*'.
  --hide-regex=REGEX    regex matching the file paths whose frames to hide.
                        Useful if --hide doesn't give enough control.
  --show=EXPR           glob-style pattern matching the file paths whose
                        frames to show, regardless of --hide or --hide-regex.
                        For example, use --show '*/<library>/*' to show frames
                        within a library that would otherwise be hidden.
  --show-regex=REGEX    regex matching the file paths whose frames to always
                        show. Useful if --show doesn't give enough control.
  --show-all            show everything
  --unicode             (text renderer only) force unicode text output
  --no-unicode          (text renderer only) force ascii text output
  --color               (text renderer only) force ansi color text output
  --no-color            (text renderer only) force no color text output

**专业提示：**将为您提供HTML形式的交互式个人资料报告 - 您 真的可以这样探索！`-r html`

## 分析特定的代码块[](https://pyinstrument.readthedocs.io/en/latest/guide.html#profile-a-specific-chunk-of-code "Permalink to this headline")

Pyinstrument 也有一个 Python API。只需用 Pyinstrument 包围您的代码， 喜欢这个：

``` python
from pyinstrument import Profiler

profiler = Profiler()
profiler.start()

# code you want to profile

profiler.stop()

profiler.print()
```

如果您收到“未记录任何样本”，是因为您的代码在 1毫秒，万岁！如果**仍**要检测代码，请设置间隔 小于默认值 0.001（1 毫秒）的值，如下所示：

profiler = Profiler(interval=0.0001)
...

尝试使用间隔值以查看不同的深度，但请记住 较小的间隔可能会影响分析的性能开销。

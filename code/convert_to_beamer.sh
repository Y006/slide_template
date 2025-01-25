#!/bin/bash

# 设置当前文件名
currentFileName="source"

# 检查 Pandoc 是否安装
if ! command -v Your pandoc path &> /dev/null; then
    echo "Error: Pandoc is not installed or not found at Your pandoc path."
    exit 1
fi

# 执行 Pandoc 转换命令
Your pandoc path "${currentFileName}.md" -t beamer -o "${currentFileName}.tex" --highlight-style=pygments
# Your pandoc path "${currentFileName}.md" -t beamer -s -o "${currentFileName}.tex" --highlight-style=pygments

# 编译 LaTeX 文件
# xelatex "${currentFileName}.tex"

# 打印成功信息
if [ $? -eq 0 ]; then
    echo "Conversion successful: ${currentFileName}.tex created."
else
    echo "Error: Conversion failed."
fi
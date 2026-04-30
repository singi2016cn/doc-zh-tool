#!/bin/bash

# 目录配置
EN_DIR="en"
ZH_DIR="zh"

# 帮助信息
show_help() {
    echo "用法：$0 [路径关键词] [数量]"
    echo "示例："
    echo "  $0                      显示所有缺失的XML文件"
    echo "  $0 appendices           搜索路径包含appendices的所有文件"
    echo "  $0 appendices 5         搜索并只显示5条"
    echo "  $0 '' 10                不过滤，显示10条"
    echo "  $0 -h                   显示帮助"
    exit 0
}

# 帮助
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# 参数交换位置
FILTER="$1"
LIMIT="${2:-}"

# 跳到项目根目录
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

# 检查目录
if [ ! -d "$EN_DIR" ]; then
    echo "错误：目录 $EN_DIR 不存在"
    exit 1
fi
if [ ! -d "$ZH_DIR" ]; then
    echo "错误：目录 $ZH_DIR 不存在"
    exit 1
fi

# 查找：支持路径过滤
find "$EN_DIR" -type f -name "*.xml" | while IFS= read -r en_file; do
    # 如果传入了过滤关键词，不匹配就跳过
    if [[ -n "$FILTER" && ! "$en_file" =~ "$FILTER" ]]; then
        continue
    fi

    zh_file="${en_file/$EN_DIR/$ZH_DIR}"
    if [ ! -e "$zh_file" ]; then
        file_path="${en_file#en/}"
        git_hash=$(cd "$EN_DIR" && git --no-pager log -n 1 --pretty=format:%H -- "$file_path" 2>/dev/null)
        [ -z "$git_hash" ] && git_hash="无Git记录"
        echo "$git_hash | $en_file"
    fi
done | if [ -n "$LIMIT" ] && [[ "$LIMIT" =~ ^[0-9]+$ ]]; then
    head -n "$LIMIT"
else
    cat
fi
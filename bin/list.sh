#!/bin/bash

# 目录配置
EN_DIR="en"
ZH_DIR="zh"

# 帮助信息
show_help() {
    echo "使用方法：$0 [数量]"
    echo "示例："
    echo "  $0        默认显示 3 条缺失的 XML 文件"
    echo "  $0 5      显示 5 条"
    echo "  $0 10     显示 10 条"
    echo "  $0 -h     显示此帮助信息"
    exit 0
}

# 参数处理
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# 限制数量（默认 3）
LIMIT="${1:-3}"

# 校验是否为纯数字
if ! [[ "$LIMIT" =~ ^[0-9]+$ ]]; then
    echo "错误：参数必须是正整数"
    show_help
    exit 1
fi

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

# 开始查找
find "$EN_DIR" -type f -name "*.xml" | while IFS= read -r en_file; do
    zh_file="${en_file/$EN_DIR/$ZH_DIR}"

    if [ ! -e "$zh_file" ]; then
        file_path="${en_file#en/}"
        git_hash=$(cd "$EN_DIR" && git --no-pager log -n 1 --pretty=format:%H -- "$file_path" 2>/dev/null)
        [ -z "$git_hash" ] && git_hash="无Git记录"
        echo "$git_hash | $en_file"
    fi
done | head -n "$LIMIT"
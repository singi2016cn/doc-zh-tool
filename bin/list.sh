#!/bin/bash

# 目录配置
EN_DIR="en"
ZH_DIR="zh"

# 默认值
FILTER=""
LIMIT="1"
SHOW_HASH=false

# 帮助信息
show_help() {
    cat <<EOF
用法：$0 [选项]

选项：
  -s, --search STR    路径搜索关键词（支持模糊匹配）
  -n, --number NUM    显示条数（默认：1）
  -H, --hash          显示 Git Hash
  -h, --help          显示帮助

示例：
  $0                            默认显示 1 条路径
  $0 -s appendices              搜索路径包含 appendices
  $0 -s bc -n 5                 搜索 bc，显示 5 条
  $0 -s bc -n 5 -H              显示 Hash
EOF
    exit 0
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--search)
            FILTER="$2"
            shift 2
            ;;
        -n|--number)
            LIMIT="$2"
            shift 2
            ;;
        -H|--hash)
            SHOW_HASH=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "错误：未知参数 $1"
            show_help
            exit 1
            ;;
    esac
done

# 校验数字
if ! [[ "$LIMIT" =~ ^[0-9]+$ ]]; then
    echo "错误：数量必须是正整数"
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

# 查找
find "$EN_DIR" -type f -name "*.xml" | while IFS= read -r en_file; do
    if [[ -n "$FILTER" && ! "$en_file" =~ "$FILTER" ]]; then
        continue
    fi

    zh_file="${en_file/$EN_DIR/$ZH_DIR}"
    if [ ! -e "$zh_file" ]; then
        if $SHOW_HASH; then
            file_path="${en_file#en/}"
            git_hash=$(cd "$EN_DIR" && git --no-pager log -n 1 --pretty=format:%H -- "$file_path" 2>/dev/null)
            [ -z "$git_hash" ] && git_hash="无Git记录"
            echo "$git_hash | $en_file"
        else
            echo "$en_file"
        fi
    fi
done | head -n "$LIMIT"
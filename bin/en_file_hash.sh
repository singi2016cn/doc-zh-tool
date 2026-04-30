#!/bin/bash

show_help() {
  echo "用法: $0 <文件路径>"
  echo ""
  echo "获取 en 目录下指定文件的最新一次 Git 提交哈希值"
  echo ""
  echo "参数:"
  echo "  文件路径    相对于 en 目录的文件路径（支持带 en/ 前缀 或 不带前缀）"
  echo "  -h, --help  显示此帮助信息"
  echo ""
  echo "示例:"
  echo "  $0 reference/array/functions/array-all.xml"
  echo "  $0 en/reference/bc/bcmath.number.xml"
  exit 0
}

# 处理帮助参数
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
fi

# 无参数则显示帮助
if [ -z "$1" ]; then
  show_help
fi

# 核心：自动去除路径开头的 en/ 前缀（兼容两种写法）
file_path="${1#en/}"

# 切换到 en 目录
cd "$(dirname "$0")/../en" || exit 1

# 查询最新提交哈希
git --no-pager log -n 1 --pretty=format:%H -- "$file_path"
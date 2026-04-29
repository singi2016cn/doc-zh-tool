#!/bin/bash

show_help() {
  echo "用法: $0 <文件路径>"
  echo ""
  echo "获取 en 目录下指定文件的最新一次 Git 提交哈希值"
  echo ""
  echo "参数:"
  echo "  文件路径    相对于 en 目录的文件路径（不包含 en/ 前缀）"
  echo "  -h, --help  显示此帮助信息"
  echo ""
  echo "示例:"
  echo "  $0 reference/array/functions/array-all.xml"
  exit 0
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
fi

if [ -z "$1" ]; then
  show_help
fi

cd "$(dirname "$0")/../en"
git --no-pager log -n1 --pretty=format:%H -- "$1"
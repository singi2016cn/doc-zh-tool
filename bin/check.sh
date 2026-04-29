#!/bin/bash

show_help() {
  echo "用法: $0 [选项]"
  echo ""
  echo "运行 doc-base/configure.php 配置脚本，检测语法是否正确，默认使用中文"
  echo ""
  echo "选项:"
  echo "  -h, --help  显示此帮助信息"
  echo ""
  echo "示例:"
  echo "  $0"
  echo "  $0 --with-lang=en"
  exit 0
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
fi

php "$(dirname "$0")/../doc-base/configure.php" --with-lang=zh "$@"
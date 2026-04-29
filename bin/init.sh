#!/bin/bash

# 带重试的 git clone
git_clone_retry() {
  local url=$1
  local dir=$2
  local max_retry=3
  local count=0

  while [ $count -lt $max_retry ]; do
    echo "尝试克隆 $dir ... ($((count+1))/$max_retry)"
    git clone --depth 1 $url $dir
    if [ $? -eq 0 ]; then
      return 0
    fi
    count=$((count+1))
    echo "克隆失败，等待 3 秒后重试..."
    sleep 3
  done

  echo "克隆 $dir 最终失败"
  exit 1
}

echo "==================================="
echo "🚀 开始初始化 PHP 文档翻译项目（自动重试）"
echo "==================================="

git clone https://github.com/singi2016cn/doc-zh-tool.git
cd doc-zh-tool || exit 1

echo "📥 克隆英文文档..."
git_clone_retry https://github.com/php/doc-en.git en

echo "📥 克隆中文文档..."
git_clone_retry https://github.com/php/doc-zh.git zh

echo "📥 克隆构建工具..."
git_clone_retry https://github.com/php/doc-base.git doc-base

echo -e "\n✅ 初始化完成！"
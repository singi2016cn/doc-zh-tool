#!/bin/bash

# 初始化 PHP 官方文档中文翻译项目
# 逻辑：先拉取工具项目 → 进入项目 → 克隆文档仓库

echo "==================================="
echo "🚀 开始初始化 PHP 文档翻译项目"
echo "==================================="

# 1. 克隆你的工具项目
echo "📥 正在下载工具项目..."
git clone https://github.com/singi2016cn/doc-zh-tool.git

# 2. 进入工具目录（失败则退出）
cd doc-zh-tool || exit 1

# 3. 克隆英文原文档
echo "📥 正在克隆英文原文档..."
git clone https://github.com/php/doc-en.git en

# 4. 克隆中文翻译文档
echo "📥 正在克隆中文翻译文档..."
git clone https://github.com/php/doc-zh.git zh

# 5. 克隆文档构建工具
echo "📥 正在克隆文档构建工具..."
git clone https://github.com/php/doc-base.git

echo -e "\n✅ 项目初始化完成！"
echo "📂 项目目录结构："
ls -la
#!/bin/bash

# 初始化 PHP 官方文档中文翻译项目（自动创建目录、拉取三个仓库）

# ===================== 新增逻辑 =====================
# 检测当前目录是否为空目录，如果是空，则直接在当前目录操作
if [ -z "$(ls -A)" ]; then
    echo "✅ 当前目录为空，直接在当前目录初始化..."
else
    # 非空则创建并进入目录
    mkdir -p phpdoc
    cd phpdoc || exit 1
fi
# ===================================================

# 克隆英文原文档
echo "正在克隆英文原文档..."
git clone https://github.com/php/doc-en.git en

# 克隆中文翻译文档
echo "正在克隆中文翻译文档..."
git clone https://github.com/php/doc-zh.git zh

# 克隆文档构建工具
echo "正在克隆文档构建工具..."
git clone https://github.com/php/doc-base.git

echo -e "\n✅ PHP 中文翻译项目初始化完成！"
echo "目录结构："
ls -la
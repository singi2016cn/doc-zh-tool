#!/bin/bash
# 新建中文翻译文件：从 en 目录下复制文件到 zh 目录，并自动计算hash，插入维护注释
# 兼容输入：en/xxx.xml 或 xxx.xml

show_help() {
  echo "用法: $0 <文件路径> [维护者名称]"
  echo ""
  echo "从 en 目录下复制文件到 zh 目录，并自动计算hash，插入维护注释"
  echo ""
  echo "参数:"
  echo "  文件路径    相对于 en 目录的文件路径（支持带 en/ 前缀 或 不带）"
  echo "  维护者名称  可选，默认: Singi"
  echo "  -h, --help  显示此帮助信息"
  echo ""
  echo "示例:"
  echo "  $0 appendices/examples.xml"
  echo "  $0 en/appendices/examples.xml"
  echo "  $0 appendices/examples.xml Tom"
  exit 0
}

# 帮助参数判断
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
fi

# 无参数判断
if [ -z "$1" ]; then
  show_help
fi

# 切换到项目根目录
cd "$(dirname "$0")/../" || exit 1

# ====================== 兼容处理：自动去掉 en/ 前缀 ======================
file_path="$1"
# 如果路径以 en/ 开头，删除前缀
if [[ "$file_path" == en/* ]]; then
  file_path="${file_path#en/}"
fi

# 定义路径
src_file="en/$file_path"
zh_path="zh/$file_path"
maintainer="${2:-Singi}"

# 检查源文件
if [ ! -f "$src_file" ]; then
  echo "错误：源文件不存在 -> $src_file"
  exit 1
fi

# 创建目录并复制
mkdir -p "$(dirname "$zh_path")"
cp -v "$src_file" "$zh_path"
echo "✅ 复制完成：$zh_path"

# 计算哈希值（捕获输出）
echo "🔍 计算文件哈希..."
hash_val=$(bin/en_file_hash.sh "$file_path")
echo "✅ 哈希值：$hash_val"

# ====================== 精准插入逻辑 ======================
echo "🔧 开始插入注释..."

# 检查目标文件是否已存在 $Revision 行
if grep -qF '<!-- $Revision$ -->' "$zh_path"; then
  echo "✅ 已存在 \$Revision\$，在下一行插入 EN-Revision"
  # 在 $Revision 下一行插入
  sed -i.bak '/<!-- \$Revision\$ -->/a<!-- EN-Revision: '"$hash_val"' Maintainer: '"$maintainer"' Status: ready -->' "$zh_path"
else
  echo "✅ 不存在 \$Revision\$，在第2、3行插入两行"
  # 第2行插入 Revision，第3行插入 EN-Revision
  sed -i.bak -e "2i<!-- \$Revision\$ -->" \
             -e "3i<!-- EN-Revision: $hash_val Maintainer: $maintainer Status: ready -->" "$zh_path"
fi

# 删除备份文件
rm -f "${zh_path}.bak"

echo -e "\n🎉 全部完成！标准格式已生成："
echo "<!-- \$Revision\$ -->"
echo "<!-- EN-Revision: $hash_val Maintainer: $maintainer Status: ready -->"
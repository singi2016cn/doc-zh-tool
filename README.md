# doc-zh-tool

为 [php/doc-zh](https://github.com/php/doc-zh) 开发的工具集。

## 快速开始

初始化项目,参数是你的克隆中文仓库地址。

```bash
curl -fsSL https://raw.githubusercontent.com/singi2016cn/doc-zh-tool/main/bin/init.sh | bash -s -- https://github.com/你的用户名/doc-zh.git
```

## 可用的命令工具

```text
|__check.sh # 语法检查
|__create_file.sh # 创建新的翻译文件
|__en_file_hash.sh # 计算文件的 hash
|__init.sh # 初始化项目
|__list.sh # 列出 zh 不存在的文件
```

### 示例

搜索 1 个还未翻译的文件，并自动填充 hash、维护者后，创建到 zh 目录下

```bash
bin/list.sh -s /bc | xargs bin/create_file.sh
```

搜索 10 个还未翻译的文件，并依次自动填充 hash、维护者后，创建到 zh 目录下

```bash
bin/list.sh -s /bc -n 10 | xargs -n 1 bin/create_file.sh
```

#!/bin/bash

# 指定 Pandoc 版本
PANDOC_VERSION="3.6.4"
ARCH="amd64"   # 对于 x86_64 架构
OS="linux"

# GitHub release URL
DOWNLOAD_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-${OS}-${ARCH}.tar.gz"

# 安装目录
INSTALL_DIR="/usr/local"

# 判断是否是 root 权限
if [ "$EUID" -ne 0 ]; then
    echo "请以 root 用户或使用 sudo 执行此脚本。"
    exit 1
fi

# 创建临时目录
TMP_DIR=$(mktemp -d)
echo "创建临时目录: $TMP_DIR"
cd "$TMP_DIR"

# 下载 Pandoc 二进制文件
echo "下载 Pandoc v${PANDOC_VERSION}..."
curl -LO "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo "❌ 下载失败！请检查版本号或网络连接。"
    exit 1
fi

# 解压下载文件
echo "正在解压文件..."
tar -xzf "pandoc-${PANDOC_VERSION}-${OS}-${ARCH}.tar.gz"

# 安装到系统目录
echo "安装 Pandoc 到 ${INSTALL_DIR}/bin..."
cp "pandoc-${PANDOC_VERSION}/bin/pandoc" "${INSTALL_DIR}/bin/"
cp "pandoc-${PANDOC_VERSION}/share/man/man1/pandoc.1.gz" "/usr/share/man/man1/"

# 更新 man 数据库
mandb > /dev/null 2>&1

# 清理临时文件
cd /
rm -rf "$TMP_DIR"

# 验证安装
echo "✅ 安装完成！当前 Pandoc 版本："
pandoc --version
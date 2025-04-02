#!/bin/bash

# 指定 Pandoc 版本
PANDOC_VERSION="3.6.4"
ARCH="amd64"   # 对于 x86_64 架构
OS="linux"

# GitHub release URL
DOWNLOAD_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-${OS}-${ARCH}.tar.gz"

# 用户安装目录
USER_BIN_DIR="$HOME/.local/bin"
USER_MAN_DIR="$HOME/.local/share/man/man1"

# 创建用户目录（如果不存在）
mkdir -p "$USER_BIN_DIR"
mkdir -p "$USER_MAN_DIR"

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

# 安装到用户目录
echo "安装 Pandoc 到 ${USER_BIN_DIR}..."
cp "pandoc-${PANDOC_VERSION}/bin/pandoc" "${USER_BIN_DIR}/"

# 复制 man 页面（如果存在）
if [ -f "pandoc-${PANDOC_VERSION}/share/man/man1/pandoc.1.gz" ]; then
    cp "pandoc-${PANDOC_VERSION}/share/man/man1/pandoc.1.gz" "${USER_MAN_DIR}/"
fi

# 清理临时文件
cd "$HOME"
rm -rf "$TMP_DIR"

# 检查 PATH 中是否包含用户 bin 目录
if [[ ":$PATH:" != *":$USER_BIN_DIR:"* ]]; then
    echo "将 $USER_BIN_DIR 添加到 PATH 环境变量中..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo "请运行 'source ~/.bashrc' 或重新登录以使环境变量生效"
fi

# 验证安装
if [ -x "$USER_BIN_DIR/pandoc" ]; then
    echo "✅ 安装完成！当前 Pandoc 版本："
    "$USER_BIN_DIR/pandoc" --version
else
    echo "⚠️ Pandoc 安装可能不完整，请检查安装路径和权限。"
fi

echo "Pandoc 已安装到: $USER_BIN_DIR/pandoc"
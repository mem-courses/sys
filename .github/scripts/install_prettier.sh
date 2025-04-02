#!/bin/bash

# 指定 Prettier 版本
PRETTIER_VERSION="3.2.5"
NODE_VERSION="20.12.2"  # Node.js 版本，Prettier 需要 Node.js 环境

# 用户安装目录
USER_BIN_DIR="$HOME/.local/bin"
USER_LIB_DIR="$HOME/.local/lib/prettier"

# 创建用户目录（如果不存在）
mkdir -p "$USER_BIN_DIR"
mkdir -p "$USER_LIB_DIR"

# 创建临时目录
TMP_DIR=$(mktemp -d)
echo "创建临时目录: $TMP_DIR"
cd "$TMP_DIR"

# 检查 Node.js 是否已安装
if ! command -v node &> /dev/null; then
    echo "Node.js 未安装，正在安装 Node.js v${NODE_VERSION}..."
    
    # 下载并安装 Node.js
    NODE_ARCH="x64"  # 默认架构
    NODE_OS="linux"  # 默认操作系统
    
    # 检测操作系统
    if [[ "$OSTYPE" == "darwin"* ]]; then
        NODE_OS="darwin"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        NODE_OS="win"
    fi
    
    # 检测架构
    if [[ "$(uname -m)" == "arm64" || "$(uname -m)" == "aarch64" ]]; then
        NODE_ARCH="arm64"
    fi
    
    NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.tar.gz"
    
    echo "下载 Node.js 从 ${NODE_URL}..."
    curl -LO "$NODE_URL"
    
    if [ $? -ne 0 ]; then
        echo "❌ Node.js 下载失败！请检查版本号或网络连接。"
        exit 1
    fi
    
    # 解压 Node.js
    echo "正在解压 Node.js..."
    tar -xzf "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.tar.gz"
    
    # 将 Node.js 二进制文件复制到用户目录
    cp "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}/bin/node" "$USER_BIN_DIR/"
    cp "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}/bin/npm" "$USER_BIN_DIR/"
    cp "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}/bin/npx" "$USER_BIN_DIR/"
    
    # 复制 npm 所需的文件
    mkdir -p "$HOME/.local/lib/node_modules"
    cp -r "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}/lib/node_modules/npm" "$HOME/.local/lib/node_modules/"
    
    echo "Node.js 安装完成！"
fi

# 安装 Prettier
echo "正在安装 Prettier v${PRETTIER_VERSION}..."

# 使用 npm 安装 Prettier
"$USER_BIN_DIR/npm" install --prefix "$USER_LIB_DIR" prettier@"$PRETTIER_VERSION"

if [ $? -ne 0 ]; then
    echo "❌ Prettier 安装失败！请检查版本号或网络连接。"
    exit 1
fi

# 创建 Prettier 启动脚本
echo "创建 Prettier 启动脚本..."
cat > "$USER_BIN_DIR/prettier" << EOF
#!/bin/bash
NODE_PATH="$USER_LIB_DIR/node_modules" "$USER_BIN_DIR/node" "$USER_LIB_DIR/node_modules/.bin/prettier" "\$@"
EOF

# 设置执行权限
chmod +x "$USER_BIN_DIR/prettier"

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
if [ -x "$USER_BIN_DIR/prettier" ]; then
    echo "✅ 安装完成！当前 Prettier 版本："
    "$USER_BIN_DIR/prettier" --version
else
    echo "⚠️ Prettier 安装可能不完整，请检查安装路径和权限。"
fi

echo "Prettier 已安装到: $USER_BIN_DIR/prettier"

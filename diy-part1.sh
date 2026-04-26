#!/bin/bash
# =====================================================================
# diy-part1.sh - 预编译脚本
# 应用补丁、配置 feeds
# =====================================================================

echo "=== 执行 diy-part1.sh ==="

# 自动检测 openwrt 目录位置
if [ -d "/workdir/openwrt" ]; then
    OPENWRT_DIR="/workdir/openwrt"
elif [ -d "$GITHUB_WORKSPACE/openwrt" ]; then
    OPENWRT_DIR="$GITHUB_WORKSPACE/openwrt"
elif [ -d "$(dirname "${BASH_SOURCE[0]}")/openwrt" ]; then
    OPENWRT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/openwrt"
else
    OPENWRT_DIR="openwrt"
fi

echo "检测到 openwrt 目录: $OPENWRT_DIR"

# 复制 feeds 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/feeds.conf" ]; then
    cp "$SCRIPT_DIR/feeds.conf" "$OPENWRT_DIR/feeds.conf.default"
    echo "✅ feeds.conf 已复制"
else
    echo "⚠️ feeds.conf 不存在，跳过"
fi

echo "=== diy-part1.sh 完成 ==="

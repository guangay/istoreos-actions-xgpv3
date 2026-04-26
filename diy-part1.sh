#!/bin/bash
# =====================================================================
# diy-part1.sh - 预编译脚本（简化版）
# 按照 immortalwrt 官方规范：只加载基本配置和 xgpv3 支持
# =====================================================================

echo "=== 执行 diy-part1.sh ==="

# 自动检测 openwrt 目录
if [ -d "/workdir/openwrt" ]; then
    OPENWRT_DIR="/workdir/openwrt"
elif [ -d "$GITHUB_WORKSPACE/openwrt" ]; then
    OPENWRT_DIR="$GITHUB_WORKSPACE/openwrt"
elif [ -d "$(dirname "${BASH_SOURCE[0]}")/openwrt" ]; then
    OPENWRT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/openwrt"
else
    OPENWRT_DIR="openwrt"
fi

echo "openwrt 目录: $OPENWRT_DIR"

# 复制 feeds 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FEEDS_CONF="$SCRIPT_DIR/rk35xx-24.10/feeds.conf"

if [ -f "$FEEDS_CONF" ]; then
    cp "$FEEDS_CONF" "$OPENWRT_DIR/feeds.conf.default"
    echo "✅ feeds.conf 已复制"
else
    # 使用内联官方配置（无第三方）
    cat > "$OPENWRT_DIR/feeds.conf.default" << 'EOF'
src-git base https://github.com/istoreos/istoreos.git;istoreos-24.10
src-git packages https://github.com/istoreos/istoreos.git;istoreos-24.10
src-git luci https://github.com/istoreos/istoreos.git;istoreos-24.10
src-git routing https://github.com/openwrt/routing.git;openwrt-23.05
src-git telephony https://github.com/openwrt/telephony.git;openwrt-23.05
EOF
    echo "✅ 使用官方默认 feeds.conf"
fi

echo "=== diy-part1.sh 完成 ==="

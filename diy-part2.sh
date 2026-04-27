#!/bin/bash
# =====================================================================
# diy-part2.sh - 配置目标设备、集成屏幕驱动和 QModem
# 注意：设备树、armv8.mk、补丁已在 YML 中复制，本脚本不再重复
# =====================================================================

echo "=== 执行 diy-part2.sh ==="

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

cd "$OPENWRT_DIR"
echo "当前目录: $(pwd)"

# =====================================================================
# 辅助函数
# =====================================================================
add_config() {
    local key="$1"
    local value="$2"
    if ! grep -q "^${key}=" .config 2>/dev/null; then
        echo "${key}=${value}" >> .config
    fi
}

disable_config() {
    local key="$1"
    if ! grep -q "^# ${key} is not set" .config 2>/dev/null; then
        echo "# ${key} is not set" >> .config
    fi
}

# =====================================================================
# 目标设备配置
# =====================================================================
echo ">>> 配置目标设备..."

add_config CONFIG_TARGET_rockchip y
add_config CONFIG_TARGET_rockchip_armv8 y
add_config CONFIG_TARGET_MULTI_PROFILE y
add_config CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3 y
add_config CONFIG_TARGET_BOARD "rockchip"
add_config CONFIG_TARGET_SUBTARGET "armv8"
add_config CONFIG_TARGET_PROFILE "DEVICE_nlnet_xgpv3"

# =====================================================================
# 屏幕驱动（xgp-v3-screen）
# =====================================================================
echo ">>> 配置屏幕驱动..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREEN_LOCAL="$SCRIPT_DIR/xgp-v3-screen"
SCREEN_PKG="package/xgp-v3-screen"

if [ -d "$SCREEN_LOCAL" ]; then
    rm -rf "$SCREEN_PKG"
    cp -r "$SCREEN_LOCAL" "$SCREEN_PKG"
    echo "✅ 使用本地 xgp-v3-screen"
elif [ -d "$SCREEN_PKG" ]; then
    echo "✅ xgp-v3-screen 已存在"
else
    git clone --depth 1 https://github.com/junhong-l/xgp-v3-screen.git "$SCREEN_PKG"
    echo "✅ xgp-v3-screen 已克隆"
fi

# =====================================================================
# QModem 支持（4G/5G 模块管理）
# =====================================================================
echo ">>> 配置 QModem..."

QMODEM_LOCAL="$SCRIPT_DIR/QModem"
QMODEM_PKG="package/QModem"

if [ -d "$QMODEM_LOCAL" ]; then
    rm -rf "$QMODEM_PKG"
    cp -r "$QMODEM_LOCAL" "$QMODEM_PKG"
    echo "✅ 使用本地 QModem"
elif [ -d "$QMODEM_PKG" ]; then
    echo "✅ QModem 已存在"
else
    git clone --depth 1 https://github.com/FUjr/QModem.git "$QMODEM_PKG"
    echo "✅ QModem 已克隆"
fi

# 添加 QModem 常用依赖包
add_config CONFIG_PACKAGE_qmi y
add_config CONFIG_PACKAGE_uqmi y
add_config CONFIG_PACKAGE_modemmanager y
add_config CONFIG_PACKAGE_libqmi y
add_config CONFIG_PACKAGE_libmbim y

# =====================================================================
# 基本系统配置
# =====================================================================
echo ">>> 配置基本系统..."

# IPv6 支持
add_config CONFIG_IPV6 y

# 禁用 third_party（按要求）
disable_config CONFIG_PACKAGE_third_party

# =====================================================================
# 编译前验证
# =====================================================================
echo ">>> 验证设备配置..."

DEVICE_CONFIG="CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3=y"
if ! grep -q "^${DEVICE_CONFIG}" .config 2>/dev/null; then
    echo "⚠️ 设备配置丢失，强制添加..."
    echo "$DEVICE_CONFIG" >> .config
fi

# 注意：make defconfig 将在 YML 中单独执行，这里不再重复，避免冲突
echo "✅ diy-part2.sh 执行完成"

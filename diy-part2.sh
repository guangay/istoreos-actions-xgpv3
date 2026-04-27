#!/bin/bash
# diy-part2.sh - 配置目标设备、内核MHI驱动、屏幕驱动、quectel-cm
# QModem 已通过 feed 集成

echo "=== 执行 diy-part2.sh ==="

# 自动检测 openwrt 目录
if [ -d "/workdir/openwrt" ]; then
    OPENWRT_DIR="/workdir/openwrt"
elif [ -d "$GITHUB_WORKSPACE/openwrt" ]; then
    OPENWRT_DIR="$GITHUB_WORKSPACE/openwrt"
else
    OPENWRT_DIR="openwrt"
fi

cd "$OPENWRT_DIR" || exit 1
echo "当前目录: $(pwd)"

# 辅助函数
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

# 目标设备配置
echo ">>> 配置目标设备..."
add_config CONFIG_TARGET_rockchip y
add_config CONFIG_TARGET_rockchip_armv8 y
add_config CONFIG_TARGET_MULTI_PROFILE y
add_config CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3 y
add_config CONFIG_TARGET_BOARD "rockchip"
add_config CONFIG_TARGET_SUBTARGET "armv8"
add_config CONFIG_TARGET_PROFILE "DEVICE_nlnet_xgpv3"

# 内核 MHI 驱动（解决 kmod-mhi-wwan）
echo ">>> 启用内核 MHI 驱动..."
add_config CONFIG_MHI_BUS y
add_config CONFIG_MHI_WWAN_CTRL y
add_config CONFIG_MHI_WWAN_MBIM y
add_config CONFIG_MHI_NET y
add_config CONFIG_MHI_PCI_GENERIC y
add_config CONFIG_PACKAGE_kmod-usb-net-qmi-wwan y
add_config CONFIG_PACKAGE_kmod-usb-net-cdc-mbim y

# 屏幕驱动
echo ">>> 配置屏幕驱动..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREEN_LOCAL="$SCRIPT_DIR/xgp-v3-screen"
SCREEN_PKG="package/xgp-v3-screen"

if [ -d "$SCREEN_LOCAL" ]; then
    rm -rf "$SCREEN_PKG"
    cp -r "$SCREEN_LOCAL" "$SCREEN_PKG"
    echo "✅ 使用本地屏幕驱动"
elif [ -d "$SCREEN_PKG" ]; then
    echo "✅ 屏幕驱动已存在"
else
    git clone --depth 1 https://github.com/junhong-l/xgp-v3-screen.git "$SCREEN_PKG"
    echo "✅ 屏幕驱动已克隆"
fi

# quectel-cm（QModem 依赖）
echo ">>> 配置 quectel-cm..."
QUECTEL_CM_PKG="package/quectel-cm"
if [ -d "$QUECTEL_CM_PKG" ]; then
    echo "✅ quectel-cm 已存在"
else
    git clone --depth 1 https://github.com/kmilo17pet/quectel-cm.git "$QUECTEL_CM_PKG"
    echo "✅ quectel-cm 已克隆"
fi
add_config CONFIG_PACKAGE_quectel-cm y

# 启用 QModem 相关包
echo ">>> 启用 QModem 包..."
add_config CONFIG_PACKAGE_luci-app-qmodem y
add_config CONFIG_PACKAGE_qmodem y

# 基本系统
echo ">>> 基本系统配置..."
add_config CONFIG_IPV6 y
disable_config CONFIG_PACKAGE_third_party

# 验证设备配置
DEVICE_CONFIG="CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3=y"
if ! grep -q "^${DEVICE_CONFIG}" .config 2>/dev/null; then
    echo "$DEVICE_CONFIG" >> .config
fi

echo "✅ diy-part2.sh 执行完成"

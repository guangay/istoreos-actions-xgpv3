#!/bin/bash
# =====================================================================
# diy-part2.sh - 配置目标设备、集成屏幕驱动、QModem 及其缺失依赖
# 包含：内核 MHI 驱动支持、quectel-cm / quectel-CM-5G 克隆
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
# 内核 MHI 驱动支持（解决 kmod-mhi-wwan 缺失）
# =====================================================================
echo ">>> 启用内核 MHI 总线驱动（用于 5G 模块）..."
add_config CONFIG_MHI_BUS y
add_config CONFIG_MHI_WWAN_CTRL y
add_config CONFIG_MHI_WWAN_MBIM y
add_config CONFIG_MHI_NET y
add_config CONFIG_MHI_PCI_GENERIC y

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
# QModem 和相关依赖（quectel-cm, quectel-CM-5G）
# =====================================================================
echo ">>> 配置 QModem 及移远模块工具..."

# 1. QModem 主程序
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

# 2. quectel-cm （移远 4G/5G 拨号工具）
QUECTEL_CM_PKG="package/quectel-cm"
if [ -d "$QUECTEL_CM_PKG" ]; then
    echo "✅ quectel-cm 已存在"
else
    git clone --depth 1 https://github.com/kmilo17pet/quectel-cm.git "$QUECTEL_CM_PKG"
    echo "✅ quectel-cm 已克隆"
fi

# 3. quectel-CM-5G （专门针对 5G 模块）
QUECTEL_CM_5G_PKG="package/quectel-CM-5G"
if [ -d "$QUECTEL_CM_5G_PKG" ]; then
    echo "✅ quectel-CM-5G 已存在"
else
    # 注意：原 QModem 仓库可能包含该工具，此处直接软链接或复制
    if [ -d "$QMODEM_PKG/quectel-CM-5G" ]; then
        cp -r "$QMODEM_PKG/quectel-CM-5G" "$QUECTEL_CM_5G_PKG"
        echo "✅ 从 QModem 复制 quectel-CM-5G"
    else
        # 备选：从其他仓库克隆（如果没有，则忽略）
        echo "⚠️ 未找到 quectel-CM-5G 源，跳过"
    fi
fi

# 添加配置选项（让它们在 .config 中生效）
add_config CONFIG_PACKAGE_quectel-cm y
add_config CONFIG_PACKAGE_quectel-CM-5G y
add_config CONFIG_PACKAGE_qmi y
add_config CONFIG_PACKAGE_uqmi y
add_config CONFIG_PACKAGE_modemmanager y
add_config CONFIG_PACKAGE_libqmi y
add_config CONFIG_PACKAGE_libmbim y

# 强制添加 QModem 自身的配置（如果它的 Makefile 定义了）
add_config CONFIG_PACKAGE_QModem y

# =====================================================================
# 基本系统配置
# =====================================================================
echo ">>> 配置基本系统..."
add_config CONFIG_IPV6 y
disable_config CONFIG_PACKAGE_third_party

# =====================================================================
# 验证设备配置
# =====================================================================
echo ">>> 验证设备配置..."
DEVICE_CONFIG="CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3=y"
if ! grep -q "^${DEVICE_CONFIG}" .config 2>/dev/null; then
    echo "⚠️ 设备配置丢失，强制添加..."
    echo "$DEVICE_CONFIG" >> .config
fi

echo "✅ diy-part2.sh 执行完成（已添加 MHI 驱动、quectel 工具）"

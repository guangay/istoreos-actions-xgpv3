#!/bin/bash
# =====================================================================
# diy-part2.sh - 按需追加配置脚本
# 在 make defconfig 生成的种子配置基础上追加必要选项
# =====================================================================

set -e

OPENWRT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/openwrt" && pwd 2>/dev/null)"
[ -z "$OPENWRT_DIR" ] && OPENWRT_DIR="${OPENWRT_DIR:-openwrt}"

echo "=== 执行 diy-part2.sh ==="
cd "$OPENWRT_DIR" || exit 1

# =====================================================================
# 辅助函数
# =====================================================================

# 安全追加配置（避免重复）
add_config() {
    local key="$1"
    local value="$2"
    if ! grep -q "^${key}=" .config 2>/dev/null; then
        echo "${key}=${value}" >> .config
    fi
}

# 安全禁用配置
disable_config() {
    local key="$1"
    # 注释掉已启用的
    sed -i "s/^${key}=/# #${key} is not set #/g" .config 2>/dev/null || true
    # 添加 not set
    if ! grep -q "^# ${key} is not set" .config 2>/dev/null; then
        echo "# ${key} is not set" >> .config
    fi
}

# =====================================================================
# 目标设备和架构
# =====================================================================
echo ">>> 配置目标设备..."

add_config "CONFIG_TARGET_rockchip" "y"
add_config "CONFIG_TARGET_rockchip_armv8" "y"
add_config "CONFIG_TARGET_MULT_PROFILE" "y"
add_config "CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3" "y"
add_config "CONFIG_DTB_nlnet_xiguapi-v3" "y"

# =====================================================================
# 5G MHI 驱动（高通方案）
# =====================================================================
echo ">>> 配置 5G MHI 驱动..."

add_config "CONFIG_KMOD_MHI_PCI_GENERIC" "y"
add_config "CONFIG_KMOD_MHI_PCI_QCOM_GEN" "y"

# =====================================================================
# USB 调制解调器
# =====================================================================
echo ">>> 配置 USB 调制解调器..."

add_config "CONFIG_KMOD_USB_NET_QMI_WWAN" "y"
add_config "CONFIG_KMOD_USB_NET_CDC_MBIM" "y"
add_config "CONFIG_KMOD_USB_NET_RNDIS_HOST" "y"
add_config "CONFIG_KMOD_USB_NET_CDC_NCM" "y"
add_config "CONFIG_KMOD_USB_NET_CDC_ETHER" "y"

# =====================================================================
# RK3568 GPIO / ADC
# =====================================================================
echo ">>> 配置 RK3568 GPIO/ADC..."

add_config "CONFIG_KMOD_INPUT_ADC_KEYS" "y"
add_config "CONFIG_SARADC" "y"
add_config "CONFIG_KMOD_SARADC_ROCKCHIP" "y"
add_config "CONFIG_KMOD_HWMON_PWMFAN" "y"
add_config "CONFIG_HWMON" "y"

# =====================================================================
# 屏幕驱动 (GC9307)
# =====================================================================
echo ">>> 配置屏幕驱动..."

add_config "CONFIG_KMOD_XGP_V3_SCREEN" "m"

# =====================================================================
# USB OTG / Type-C
# =====================================================================
echo ">>> 配置 USB OTG..."

add_config "CONFIG_USB_ROLE_SWITCH" "y"
add_config "CONFIG_TYPEC" "y"
add_config "CONFIG_TYPEC_RT1711S" "y"
add_config "CONFIG_USB_GADGET" "y"
add_config "CONFIG_USB_CONFIGFS" "y"

# =====================================================================
# PCIe (5G 模组)
# =====================================================================
echo ">>> 配置 PCIe..."

add_config "CONFIG_PCIE_ROCKCHIP" "y"
add_config "CONFIG_PCI" "y"
add_config "CONFIG_PCI_MSI" "y"

# =====================================================================
# 网络配置
# =====================================================================
echo ">>> 配置网络..."

add_config "CONFIG_IPV6" "y"
add_config "CONFIG_BRIDGE" "y"
add_config "CONFIG_NET_IPIP" "y"
add_config "CONFIG_NET_IPGRE" "y"
add_config "CONFIG_NET_IPVTI" "y"

# =====================================================================
# LuCI - 调制解调器管理
# =====================================================================
echo ">>> 配置 LuCI 应用..."

add_config "CONFIG_PACKAGE_luci-proto-modemmanager" "y"
add_config "CONFIG_PACKAGE_luci-app-modemmanager" "y"
add_config "CONFIG_PACKAGE_luci-proto-qmi" "y"
add_config "CONFIG_PACKAGE_luci-proto-ncm" "y"
add_config "CONFIG_PACKAGE_luci-proto-ppp" "y"

# =====================================================================
# QMI 工具
# =====================================================================
echo ">>> 配置 QMI 工具..."

add_config "CONFIG_PACKAGE_qmi-utils" "y"
add_config "CONFIG_PACKAGE_umbim" "y"
add_config "CONFIG_PACKAGE_atinout" "y"

# =====================================================================
# USB 工具
# =====================================================================
echo ">>> 配置 USB 工具..."

add_config "CONFIG_PACKAGE_usbmuxd" "y"
add_config "CONFIG_PACKAGE_usbutils" "y"
add_config "CONFIG_PACKAGE_kmod-usb-storage" "y"
add_config "CONFIG_PACKAGE_kmod-usb-storage-expert" "y"

# =====================================================================
# 存储支持
# =====================================================================
echo ">>> 配置存储..."

add_config "CONFIG_KMOD_SATA_AHCI_ROCKCHIP" "y"
add_config "CONFIG_KMOD_SDHC" "y"
add_config "CONFIG_KMOD_MMC" "y"
add_config "CONFIG_KMOD_SCSI" "y"

# =====================================================================
# 内核构建信息
# =====================================================================
add_config "CONFIG_KERNEL_BUILD_USER" "guangay"
add_config "CONFIG_KERNEL_BUILD_DOMAIN" "GitHub-Actions"

# =====================================================================
# 生成完整配置
# =====================================================================
echo ">>> 验证配置..."
make defconfig 2>/dev/null || true

echo "=== diy-part2.sh 完成 ==="
echo "配置行数: $(wc -l < .config)"
echo "设备配置: $(grep "DEVICE_nlnet_xiguapi-v3" .config | head -1)"

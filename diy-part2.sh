#!/bin/bash
# =====================================================================
# diy-part2.sh - 内核配置与软件包配置
# 针对 nlnet_xiguapi-v3 (RK3568) 设备
# =====================================================================

echo "=== 执行 diy-part2.sh ==="

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

cd "$OPENWRT_DIR"
echo "当前目录: $(pwd)"

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
    if ! grep -q "^# ${key} is not set" .config 2>/dev/null; then
        echo "# ${key} is not set" >> .config
    fi
}

# =====================================================================
# 目标设备配置
# =====================================================================
echo ">>> 配置目标设备..."
# 基础 Rockchip 目标配置（必须先设置）
add_config CONFIG_TARGET_rockchip y
add_config CONFIG_TARGET_rockchip_armv8 y
add_config CONFIG_TARGET_MULTI_PROFILE y
add_config CONFIG_TARGET_ARMARM_V8_ARM_V8A y
add_config CONFIG_TARGET_armvirt_64_VIRTBOARD_VIRT y
add_config CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3 y
add_config CONFIG_TARGET_BOARD "rockchip"
add_config CONFIG_TARGET_SUBTARGET "armv8"
add_config CONFIG_TARGET_PROFILE "DEVICE_nlnet_xiguapi-v3"

# =====================================================================
# 5G MHI 驱动 (高通方案)
# =====================================================================
echo ">>> 配置 5G MHI 驱动..."
add_config CONFIG_KMOD_MHI_PCI_GENERIC y
add_config CONFIG_KMOD_MHI_PCI_QCOM_GEN y

# =====================================================================
# USB 调制解调器支持
# =====================================================================
echo ">>> 配置 USB 调制解调器..."
add_config CONFIG_PACKAGE_kmod-usb-qmi-dmux y
add_config CONFIG_PACKAGE_kmod-usb-net-qmi-wwan y
add_config CONFIG_PACKAGE_kmod-usb-net-cdc-mbim y
add_config CONFIG_PACKAGE_kmod-usb-net-rndis y
add_config CONFIG_PACKAGE_kmod-usb-net-cdc-ncm y
add_config CONFIG_PACKAGE_kmod-usb-net-cdc-ether y

# =====================================================================
# RK3568 GPIO/ADC 支持
# =====================================================================
echo ">>> 配置 RK3568 GPIO/ADC..."
add_config CONFIG_PACKAGE_kmod-gpio-button-hotplug m
add_config CONFIG_PACKAGE_kmod-adc-lib函式库 m
add_config CONFIG_PACKAGE_kmod-saradc m
add_config CONFIG_PACKAGE_kmod-pwm-fan m

# =====================================================================
# 屏幕驱动 (GC9307)
# =====================================================================
echo ">>> 配置屏幕驱动..."
add_config CONFIG_PACKAGE_kmod-spi-gpio m
add_config CONFIG_PACKAGE_xgp-v3-screen m

# =====================================================================
# USB OTG / Type-C 支持
# =====================================================================
echo ">>> 配置 USB OTG / Type-C..."
add_config CONFIG_PACKAGE_kmod-usb-gadget m
add_config CONFIG_PACKAGE_kmod-usb-gadget-eth m
add_config CONFIG_PACKAGE_kmod-usb-roles m
add_config CONFIG_PACKAGE_kmod-usb-typec m
add_config CONFIG_PACKAGE_kmod-usbpd-dpm7791 m
add_config CONFIG_PACKAGE_kmod-i2c-designware m
add_config CONFIG_PACKAGE_kmod-i2c-gpio m
add_config CONFIG_PACKAGE_kmod-i2c-mux-pinctrl m

# =====================================================================
# PCIe 配置 (5G 模组)
# =====================================================================
echo ">>> 配置 PCIe..."
add_config CONFIG_PCIE_BROKEN_RC_BAR y
add_config CONFIG_PCIE_DW y

# =====================================================================
# 网络配置
# =====================================================================
echo ">>> 配置网络..."
add_config CONFIG_IPV6 y
add_config CONFIG_BRIDGE y
add_config CONFIG_PACKAGE_kmod-ipip y
add_config CONFIG_PACKAGE_kmod-gre y
add_config CONFIG_PACKAGE_kmod-ip-vti y
add_config CONFIG_PACKAGE_kmod-nf-conntrack-netlink y

# =====================================================================
# LuCI 应用
# =====================================================================
echo ">>> 配置 LuCI 应用..."
add_config CONFIG_PACKAGE_luci-app-modemmanager y
add_config CONFIG_PACKAGE_luci-proto-modemmanager y
add_config CONFIG_PACKAGE_luci-proto-qmi y
add_config CONFIG_PACKAGE_luci-proto-ncm y
add_config CONFIG_PACKAGE_luci-proto-ppp y
add_config CONFIG_PACKAGE_luci-proto-qmi m
add_config CONFIG_PACKAGE_luci-proto-ncm m

# =====================================================================
# QMI 工具
# =====================================================================
echo ">>> 配置 QMI 工具..."
add_config CONFIG_PACKAGE_qmi-utils y
add_config CONFIG_PACKAGE_umbim y
add_config CONFIG_PACKAGE_atinout m
add_config CONFIG_PACKAGE_uqmi y

# =====================================================================
# USB 工具
# =====================================================================
echo ">>> 配置 USB 工具..."
add_config CONFIG_PACKAGE_usbmuxd y
add_config CONFIG_PACKAGE_usbutils y
add_config CONFIG_PACKAGE_usbreset y
add_config CONFIG_PACKAGE_libusb-1.0 y

# =====================================================================
# 存储支持
# =====================================================================
echo ">>> 配置存储支持..."
add_config CONFIG_PACKAGE_kmod-ata-ahci m
add_config CONFIG_PACKAGE_kmod-sdhci m
add_config CONFIG_PACKAGE_kmod-mmc m
add_config CONFIG_PACKAGE_kmod-scsi-core m
add_config CONFIG_PACKAGE_kmod-usb-storage m
add_config CONFIG_PACKAGE_kmod-fs-ext4 m
add_config CONFIG_PACKAGE_kmod-fs-vfat m
add_config CONFIG_PACKAGE_kmod-fs-ntfs m
add_config CONFIG_PACKAGE_ntfs-3g m
add_config CONFIG_PACKAGE_kmod-fs-exfat m
add_config CONFIG_PACKAGE_kmod-fs-btrfs m
add_config CONFIG_PACKAGE_kmod-dm m
add_config CONFIG_PACKAGE_kmod-dm-wwatian m
add_config CONFIG_PACKAGE_dosfstools m
add_config CONFIG_PACKAGE_ntfs-3g m
add_config CONFIG_PACKAGE_exfat-fsck m
add_config CONFIG_PACKAGE_kmod-scsi-generic m

# =====================================================================
# 禁用第三方 (third_party)
# =====================================================================
echo ">>> 禁用 third_party..."
disable_config CONFIG_PACKAGE_third_party

# =====================================================================
# 编译前最终确保设备配置
# =====================================================================
echo ">>> 编译前最终确保设备配置..."
if ! grep -q "CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3=y" .config 2>/dev/null; then
    echo "CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3=y" >> .config
    echo "✅ 已添加设备配置"
fi

# 验证并更新配置
make defconfig
echo "✅ 配置已更新 ($(wc -l < .config) 行)"

echo "=== diy-part2.sh 执行完成 ==="

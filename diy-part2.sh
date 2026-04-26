#!/bin/bash
#
# diy-part2.sh：为 nlnet_xiguapi-v3 添加设备支持并注入自定义配置
#

set -e

echo ">>> 添加 xiguapi-v3 设备定义到 armv8.mk ..."
TARGET_MK="target/linux/rockchip/image/armv8.mk"
if [ -f "$TARGET_MK" ]; then
    # 检查是否已经添加过，避免重复
    if ! grep -q "nlnet_xiguapi-v3" "$TARGET_MK"; then
        cat >> "$TARGET_MK" << 'EOF'

define Device/nlnet_xiguapi-v3
  $(Device/rk3568)
  DEVICE_VENDOR := NLnet
  DEVICE_MODEL := XiGuaPi V3
  DEVICE_PACKAGES := kmod-hwmon-pwmfan kmod-input-adc-keys kmod-saradc-rockchip
endef
TARGET_DEVICES += nlnet_xiguapi-v3
EOF
        echo "✅ 已添加 xiguapi-v3 设备定义"
    else
        echo "⚠️ 设备定义已存在，跳过"
    fi
else
    echo "❌ 找不到 $TARGET_MK，请检查路径"
    exit 1
fi

echo ">>> 应用 xgp.config 中的配置项 ..."
if [ -f "$GITHUB_WORKSPACE/xgp.config" ]; then
    cp "$GITHUB_WORKSPACE/xgp.config" .config
else
    echo "⚠️ 未找到 xgp.config，将使用当前 .config 并手动追加关键项"
fi

# 强制选中目标设备
echo "CONFIG_TARGET_rockchip=y" >> .config
echo "CONFIG_TARGET_rockchip_armv8=y" >> .config
echo "CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3=y" >> .config

# 追加必要的内核模块（来源于 xgp.config 和你的硬件需求）
# 注意：这里只添加关键项，避免过多冗余
cat >> .config << 'EOF'
# 有线网卡驱动
CONFIG_PACKAGE_kmod-r8125=y
CONFIG_PACKAGE_kmod-igc=y

# WiFi驱动 (MT7915E + MT7603E)
CONFIG_PACKAGE_kmod-mt7915e=y
CONFIG_PACKAGE_kmod-mt7603e=y

# USB 和 PCIe 基础
CONFIG_PACKAGE_kmod-usb3=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-net=y
CONFIG_PACKAGE_kmod-pcie-bus=y

# 显示和屏幕（如果有屏幕驱动）
# CONFIG_PACKAGE_kmod-drm=y
# CONFIG_PACKAGE_kmod-fb=y

# 文件系统
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-fs-ntfs=y
CONFIG_PACKAGE_kmod-fuse=y

# 常用工具
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-app-store=y
CONFIG_PACKAGE_iStore=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_kmod-ata-core=y
CONFIG_PACKAGE_kmod-ata-ahci=y
EOF

# 应用 LAN IP 和系统名称（Workflow 会用 sed 直接改文件，这里也可以做）
# 已经在 Workflow 中设置，这里略过

echo "✅ diy-part2.sh 执行完毕"

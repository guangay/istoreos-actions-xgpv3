#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# =====================================================
# 移除不需要的组件
# =====================================================

# 移除 ddnsto（可选）
sed -i 's/CONFIG_PACKAGE_ddnsto=y/# CONFIG_PACKAGE_ddnsto is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-ddnsto=y/# CONFIG_PACKAGE_luci-app-ddnsto is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-i18n-ddnsto-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-ddnsto-zh-cn is not set/' .config

# 移除 bootstrap 主题
sed -i 's/CONFIG_PACKAGE_luci-theme-bootstrap=y/# CONFIG_PACKAGE_luci-theme-bootstrap is not set/' .config

# 删除 webdav2 (不需要)
sed -i '/CONFIG_PACKAGE_webdav2/d' .config
echo "✅ 已删除 webdav2 配置"

# =====================================================
# 禁用 LCD/OLED 屏幕应用（使用 xgp-v3-screen 专用驱动）
# =====================================================
echo ">>> 禁用 lcdsimple 和 luci-app-oled..."

# 禁用 lcdsimple
sed -i 's/CONFIG_PACKAGE_lcdsimple=y/# CONFIG_PACKAGE_lcdsimple is not set/' .config
if ! grep -q "^# CONFIG_PACKAGE_lcdsimple is not set" .config; then
    echo "# CONFIG_PACKAGE_lcdsimple is not set" >> .config
fi
echo "CONFIG_PACKAGE_lcdsimple=n" >> .config

# 禁用 luci-app-oled
sed -i 's/CONFIG_PACKAGE_luci-app-oled=y/# CONFIG_PACKAGE_luci-app-oled is not set/' .config
if ! grep -q "^# CONFIG_PACKAGE_luci-app-oled is not set" .config; then
    echo "# CONFIG_PACKAGE_luci-app-oled is not set" >> .config
fi
echo "CONFIG_PACKAGE_luci-app-oled=n" >> .config

echo "✅ 已禁用 lcdsimple 和 luci-app-oled"

# =====================================================
# 修复 RK3568 设备配置 (使用存在的设备作为基础)
# =====================================================
echo ">>> 修复 RK3568 设备配置..."

# 由于 nlnet_xiguapi-v3 在 iStoreOS 中不存在，需要使用一个存在的设备
# 这里使用 easepi_r1 作为基础设备（RK3568），然后通过设备树覆盖
# 先注释掉不存在的设备
sed -i 's/CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3=y/# CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3 is not set/' .config
echo "# CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xiguapi-v3 is not set" >> .config

# 启用一个存在的 RK3568 设备作为基础 (easepi_r1)
# 这样可以让构建系统正确处理 U-Boot 等依赖
if ! grep -q "^CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_easepi_r1=y" .config 2>/dev/null; then
    echo "CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_easepi_r1=y" >> .config
fi

echo "✅ 设备配置已修复 (使用 easepi_r1 作为基础)"

# =====================================================
# xgp-v3 追加配置
# =====================================================

# QModem 5G模组管理
echo "
# QModem 5G模组管理
CONFIG_PACKAGE_luci-app-qmodem=y
CONFIG_PACKAGE_luci-app-qmodem-sms=y
CONFIG_PACKAGE_luci-app-qmodem-mwan=y
CONFIG_PACKAGE_luci-app-qmodem-ttl=y
" >> .config

# xgp-v3 屏幕驱动
echo "
# xgp-v3 屏幕驱动
CONFIG_PACKAGE_kmod-fb-tft=y
CONFIG_PACKAGE_kmod-fb-tft-gc9307=y
CONFIG_PACKAGE_xgp-v3-screen=y

# 屏幕驱动依赖
CONFIG_PACKAGE_libpthread=y
CONFIG_PACKAGE_libstdcpp=y
CONFIG_PACKAGE_python3=y
" >> .config

# 5G模组相关
echo "
# 5G模组短信插件
CONFIG_PACKAGE_luci-app-sms-tool=y

# 5G模组信息插件
CONFIG_PACKAGE_sms-tool=y
CONFIG_PACKAGE_luci-app-modem=y
CONFIG_PACKAGE_kmod-qmi_wwan_q=y

# 脚本拨号工具依赖
CONFIG_PACKAGE_procps-ng=y
CONFIG_PACKAGE_procps-ng-ps=y
" >> .config

# =====================================================
# 修复 RK3568 U-Boot 包配置 (解决编译错误)
# =====================================================
echo ">>> 修复 U-Boot 包配置..."

# 首先禁用 uboot-rk35xx 及其所有 variant (这个包是给 RK3528/RK3588 用的)
# 使用最强力的禁用方式
echo "# =====================================================" >> .config
echo "# 强制禁用 uboot-rk35xx (RK3528/RK3588 设备用，不兼容 RK3568)" >> .config
echo "# =====================================================" >> .config

# 注释掉所有包含 uboot-rk35xx 的配置行
sed -i '/CONFIG_PACKAGE_uboot-rk35xx/s/^/# /' .config
sed -i '/CONFIG_PACKAGE_uboot-rockchip-easepi-rk3528/s/^/# /' .config

# 禁用所有 uboot-rockchip 的 variant，只保留核心包
# uboot-rockchip 核心包会使用默认的设备树配置
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-easepi/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-fastrhino/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-friendlyarm/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-hinlink/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-lyt/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-radxa/s/^/# /' .config
sed -i '/^CONFIG_PACKAGE_uboot-rockchip-xunlong/s/^/# /' .config

# 确保启用 uboot-rockchip 核心包（不带任何 variant）
if grep -q "^# CONFIG_PACKAGE_uboot-rockchip is not set" .config 2>/dev/null; then
    sed -i 's/^# CONFIG_PACKAGE_uboot-rockchip is not set/CONFIG_PACKAGE_uboot-rockchip=y/' .config
elif ! grep -q "^CONFIG_PACKAGE_uboot-rockchip=y" .config 2>/dev/null; then
    echo "CONFIG_PACKAGE_uboot-rockchip=y" >> .config
fi

# 显式禁用所有已知的 variant
for variant in easepi-rk3568 easepi-rk3528 easepi-r1 fastrhino friendlyarm hinlink lyt radxa xunlong; do
    if ! grep -q "^# CONFIG_PACKAGE_uboot-rockchip-${variant} is not set" .config 2>/dev/null; then
        echo "# CONFIG_PACKAGE_uboot-rockchip-${variant} is not set" >> .config
    fi
done

echo "✅ U-Boot 配置完成 (仅启用 uboot-rockchip 核心包)"

echo "============================================"
echo "✅ 编译配置完成!"
echo "✅ 已添加: QModem + xgp-v3 屏幕驱动"
echo "✅ 已禁用: webdav2 + lcdsimple + luci-app-oled"
echo "✅ 已禁用: third_party (feeds.conf)"
echo "✅ 已修复: U-Boot (uboot-rk35xx -> uboot-rockchip)"
echo "============================================"

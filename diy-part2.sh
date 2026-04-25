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
# 禁用 linkease_nas feed 中有问题的包
# =====================================================
echo ">>> 禁用 linkease_nas 中有问题的包..."

# 禁用 webdav2 (依赖问题，编译失败)
sed -i 's/CONFIG_PACKAGE_webdav2=y/# CONFIG_PACKAGE_webdav2 is not set/' .config
if ! grep -q "^# CONFIG_PACKAGE_webdav2 is not set" .config; then
    echo "# CONFIG_PACKAGE_webdav2 is not set" >> .config
fi
echo "CONFIG_PACKAGE_webdav2=n" >> .config

echo "✅ 已禁用 webdav2"

# =====================================================
# 复制 xgp-v3 设备树文件
# =====================================================
echo ">>> 检查 xgp-v3 设备树文件..."

# 设备树文件由工作流中的 "下载软件包并修复uboot" 步骤负责复制
# 此处仅检查是否存在，无需报错终止

# 验证设备树文件 (由工作流复制)
if [ -f "target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-xiguapi-v3.dts" ]; then
    echo "✅ 设备树文件已就位"
else
    echo "ℹ️ 设备树将由工作流后续步骤复制"
fi

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
# 修复 RK3568 U-Boot 包 (解决编译错误)
# =====================================================
echo ">>> 修复 U-Boot 包配置 (RK3568 -> uboot-rockchip)..."

# 强制禁用 uboot-rk35xx 及其所有 variant (不支持 RK3568)
sed -i 's/CONFIG_PACKAGE_uboot-rk35xx=y/# CONFIG_PACKAGE_uboot-rk35xx is not set/' .config
sed -i 's/CONFIG_PACKAGE_uboot-rk35xx-/# CONFIG_PACKAGE_uboot-rk35xx-/' .config
echo '# 强制禁用 uboot-rk35xx' >> .config
echo 'CONFIG_PACKAGE_uboot-rk35xx=n' >> .config

# 启用 uboot-rockchip (支持 RK3568)
if grep -q "^# CONFIG_PACKAGE_uboot-rockchip is not set" .config 2>/dev/null; then
    sed -i 's/^# CONFIG_PACKAGE_uboot-rockchip is not set/CONFIG_PACKAGE_uboot-rockchip=y/' .config
elif ! grep -q "^CONFIG_PACKAGE_uboot-rockchip=y" .config 2>/dev/null; then
    echo "CONFIG_PACKAGE_uboot-rockchip=y" >> .config
fi

# 禁用 easepi-rk3568 variant（使用 xgp-v3 专用设备树）
if grep -q "^CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568=y" .config 2>/dev/null; then
    sed -i 's/^CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568=y/# CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568 is not set/' .config
fi
echo "# CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568 is not set" >> .config
echo "CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568=n" >> .config

echo "✅ U-Boot 使用 xgp-v3 专用设备树 (已禁用 easepi-rk3568)"

echo "============================================"
echo "✅ 编译配置完成!"
echo "✅ 已添加: QModem + xgp-v3 屏幕驱动"
echo "✅ 已禁用: lcdsimple + luci-app-oled + easepi-rk3568 + webdav2"
echo "✅ 已修复: U-Boot (uboot-rk35xx -> uboot-rockchip)"
echo "============================================"

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

# 串口调试工具 (暂时禁用，编译失败)
# CONFIG_PACKAGE_minicom=y

# 脚本拨号工具依赖
CONFIG_PACKAGE_procps-ng=y
CONFIG_PACKAGE_procps-ng-ps=y
" >> .config

# =====================================================
# 修复 RK3568 U-Boot 包 (解决编译错误)
# =====================================================
# 问题: nlnet_xiguapi-v3 是 RK3568 设备，但默认使用了 uboot-rk35xx 包
# uboot-rk35xx 只支持 RK3528/RK3576，不支持 RK3568！
# 解决: 切换到 uboot-rockchip 包，它支持 RK3568
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

# 复制设备树到 uboot-rockchip 源码目录 (uboot-rockchip 使用 arm64 路径)
echo ">>> 复制设备树到 uboot-rockchip 源码..."
DEVICE_TREE="rk3568-xiguapi-v3.dts"
# 从 openwrt 目录返回上级，查找用户仓库中的设备树文件
DTS_SOURCE="../target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/${DEVICE_TREE}"
DTS_TARGET_DIR="package/boot/uboot-rockchip/files/arch/arm64/boot/dts/rockchip/"

if [ -f "${DTS_SOURCE}" ]; then
    mkdir -p "${DTS_TARGET_DIR}"
    cp -f "${DTS_SOURCE}" "${DTS_TARGET_DIR}"
    echo "✅ 设备树已复制到 uboot-rockchip: ${DEVICE_TREE}"
    ls -la "${DTS_TARGET_DIR}${DEVICE_TREE}"
else
    echo "⚠️ 警告: 设备树文件不存在: ${DTS_SOURCE}"
    echo ">>> U-Boot 将使用内置设备树继续编译..."
fi

echo "============================================"
echo "✅ 编译配置完成!"
echo "✅ 已添加: QModem + xgp-v3 屏幕驱动"
echo "✅ 已禁用: lcdsimple + luci-app-oled + easepi-rk3568"
echo "✅ 已修复: U-Boot (uboot-rk35xx -> uboot-rockchip)"
echo "✅ 设备树: 使用 xgp-v3 专用 rk3568-xiguapi-v3.dts"
echo "============================================"

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

# 修改openwrt登陆地址,把下面的 192.168.10.1 修改成你想要的就可以了
# sed -i 's/192.168.100.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStore OS/g' package/base-files/files/bin/config_generate

# ttyd 自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config

# =====================================================
# xgp-v3 设备专用配置
# =====================================================

# 移除 ddnsto（可选）
sed -i 's/CONFIG_PACKAGE_ddnsto=y/CONFIG_PACKAGE_ddnsto=n/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-ddnsto=y/CONFIG_PACKAGE_luci-app-ddnsto=n/' .config
sed -i 's/CONFIG_PACKAGE_luci-i18n-ddnsto-zh-cn=y/CONFIG_PACKAGE_luci-i18n-ddnsto-zh-cn=n/' .config

# 移除 bootstrap 主题
sed -i 's/CONFIG_PACKAGE_luci-theme-bootstrap=y/CONFIG_PACKAGE_luci-theme-bootstrap=n/' .config

# =====================================================
# 添加 xgp-v3 屏幕驱动 (已在 workflow 中单独克隆)
# 注意: xgp-v3-screen 是独立包，不是 feeds 源，无需通过 feeds 安装
# =====================================================
# echo ">>> 安装 xgp-v3 屏幕驱动..."
# 已由 workflow step '克隆 xgp_screen 屏幕驱动' 单独处理

# =====================================================
# 添加 QModem 5G模组管理 (已在 workflow 中单独处理)
# 注意: modem_feeds 是独立包，不是 feeds 源
# =====================================================
# echo ">>> 安装 QModem 5G模组管理..."
# 已由 feeds install -a -p modem 在加载 feeds 时处理

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

# 禁用 uboot-rk35xx (不支持 RK3568)
sed -i 's/CONFIG_PACKAGE_uboot-rk35xx=y/# CONFIG_PACKAGE_uboot-rk35xx is not set/' .config

# 启用 uboot-rockchip (支持 RK3568)
if grep -q "^# CONFIG_PACKAGE_uboot-rockchip is not set" .config 2>/dev/null; then
    sed -i 's/^# CONFIG_PACKAGE_uboot-rockchip is not set/CONFIG_PACKAGE_uboot-rockchip=y/' .config
elif ! grep -q "^CONFIG_PACKAGE_uboot-rockchip=y" .config 2>/dev/null; then
    echo "CONFIG_PACKAGE_uboot-rockchip=y" >> .config
fi

# 选择 RK3568 的 U-Boot 目标 (使用 easepi-rk3568 作为通用目标)
if grep -q "^# CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568 is not set" .config 2>/dev/null; then
    sed -i 's/^# CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568 is not set/CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568=y/' .config
elif ! grep -q "^CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568=y" .config 2>/dev/null; then
    echo "CONFIG_PACKAGE_uboot-rockchip-easepi-rk3568=y" >> .config
fi

echo "✅ U-Boot 包已切换到 uboot-rockchip (支持 RK3568)"

# 复制设备树到 uboot-rockchip 源码目录 (uboot-rockchip 使用 arm64 路径)
echo ">>> 复制设备树到 uboot-rockchip 源码..."
DEVICE_TREE="rk3568-xiguapi-v3.dts"
DTS_SOURCE="target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/${DEVICE_TREE}"
DTS_TARGET_DIR="package/boot/uboot-rockchip/files/arch/arm64/boot/dts/rockchip/"

if [ -f "${DTS_SOURCE}" ]; then
    mkdir -p "${DTS_TARGET_DIR}"
    cp -f "${DTS_SOURCE}" "${DTS_TARGET_DIR}"
    echo "✅ 设备树已复制到 uboot-rockchip: ${DEVICE_TREE}"
    ls -la "${DTS_TARGET_DIR}${DEVICE_TREE}"
else
    echo "❌ 错误: 设备树文件不存在: ${DTS_SOURCE}"
fi

echo "============================================"
echo "✅ 编译配置完成!"
echo "✅ 已添加: QModem + xgp-v3 屏幕驱动"
echo "✅ 已修复: U-Boot (uboot-rk35xx -> uboot-rockchip)"
echo "✅ 已修复: U-Boot 设备树"
echo "============================================"

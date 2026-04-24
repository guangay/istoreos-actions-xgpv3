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
# 添加 xgp-v3 屏幕驱动 (从 feeds 安装)
# =====================================================
echo ">>> 安装 xgp-v3 屏幕驱动..."
./scripts/feeds update xgp_screen
./scripts/feeds install -a -p xgp_screen

# =====================================================
# 添加 QModem 5G模组管理 (从 feeds 安装)
# =====================================================
echo ">>> 安装 QModem 5G模组管理..."
./scripts/feeds update modem
./scripts/feeds install -a -p modem

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

# 串口调试工具
CONFIG_PACKAGE_minicom=y

# 脚本拨号工具依赖
CONFIG_PACKAGE_procps-ng=y
CONFIG_PACKAGE_procps-ng-ps=y
" >> .config

# 复制 xgpv3 设备树（如果存在）
if [ -f "$GITHUB_WORKSPACE/configs/rk3568-xiguapi-v3.dts" ]; then
    mkdir -p target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
    cp -f "$GITHUB_WORKSPACE/configs/rk3568-xiguapi-v3.dts" \
        target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
fi

echo "============================================"
echo "✅ 编译配置完成!"
echo "✅ 已添加: QModem + xgp-v3 屏幕驱动"
echo "============================================"

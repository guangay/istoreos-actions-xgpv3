#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before ./scripts/feeds update)

# =====================================================
# 预置 uboot 配置 (必须在 make defconfig 之前)
# =====================================================
# 问题: nlnet_xiguapi-v3 是 RK3568 设备，设备 profile 会自动选中 uboot-rk35xx
# uboot-rk35xx 只支持 RK3528/RK3576，不支持 RK3568！
# 解决: 在 make defconfig 之前禁用 uboot-rk35xx，这样 Kconfig 就不会自动选中它

echo ">>> 预置 U-Boot 配置 (禁用 uboot-rk35xx)..."

# 预置禁用 uboot-rk35xx (在 .config 存在时修改)
if [ -f .config ]; then
    sed -i 's/CONFIG_PACKAGE_uboot-rk35xx=y/# CONFIG_PACKAGE_uboot-rk35xx is not set/' .config
    echo "✅ uboot-rk35xx 已禁用 (预置)"
fi

#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# =====================================================
# 禁用与 iStoreOS 24.10 不兼容的 feeds
# =====================================================
echo ">>> 禁用不兼容的 feeds..."

if [ -f feeds.conf.default ]; then
    # 禁用 third_party feed (Makefile 错误)
    sed -i 's|^src-.*third_party|# src-third_party|' feeds.conf.default
    
    # 禁用 jjm2473_apps feed (Makefile 错误)
    sed -i 's|^src-.*jjm2473_apps|# src-jjm2473_apps|' feeds.conf.default
    
    echo "✅ 已禁用 third_party 和 jjm2473_apps feeds"
fi

echo ">>> diy-part1.sh 完成"

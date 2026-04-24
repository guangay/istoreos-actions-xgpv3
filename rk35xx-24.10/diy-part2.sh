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
# sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config\_generate

# 修改子网掩码
#sed -i 's/255.255.255.0/255.255.0.0/g' package/base-files/files/bin/config\_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStore OS/g' package/base-files/files/bin/config\_generate

# ttyd自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB\_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config

#添加设备
# $GITHUB\_WORKSPACE/scripts/add-device.sh

# 移除ddns
# sed -i 's/CONFIG\_PACKAGE\_ddns-scripts=y/CONFIG\_PACKAGE\_ddns-scripts=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ddns-scripts-cloudflare=y/CONFIG\_PACKAGE\_ddns-scripts-cloudflare=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ddns-scripts-dnspod=y/CONFIG\_PACKAGE\_ddns-scripts-dnspod=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ddns-scripts-services=y/CONFIG\_PACKAGE\_ddns-scripts-services=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ddns-scripts\_aliyun=y/CONFIG\_PACKAGE\_ddns-scripts\_aliyun=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_luci-app-ddns=y/CONFIG\_PACKAGE\_luci-app-ddns=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_luci-i18n-ddns-zh-cn=y/CONFIG\_PACKAGE\_luci-i18n-ddns-zh-cn=n/' .config
# 移除ddnsto
sed -i 's/CONFIG\_PACKAGE\_ddnsto=y/CONFIG\_PACKAGE\_ddnsto=n/' .config
sed -i 's/CONFIG\_PACKAGE\_luci-app-ddnsto=y/CONFIG\_PACKAGE\_luci-app-ddnsto=n/' .config
sed -i 's/CONFIG\_PACKAGE\_luci-i18n-ddnsto-zh-cn=y/CONFIG\_PACKAGE\_luci-i18n-ddnsto-zh-cn=n/' .config

# 移除网卡驱动
# sed -i 's/CONFIG\_PACKAGE\_kmod-ath=y/CONFIG\_PACKAGE\_kmod-ath=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-ath10k=y/CONFIG\_PACKAGE\_kmod-ath10k=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ath10k-board-qca9888=y/CONFIG\_PACKAGE\_ath10k-board-qca9888=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ath10k-board-qca988x=y/CONFIG\_PACKAGE\_ath10k-board-qca988x=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ath10k-board-qca9984=y/CONFIG\_PACKAGE\_ath10k-board-qca9984=n/' .config   
# sed -i 's/CONFIG\_PACKAGE\_ath10k-firmware-qca9888=y/CONFIG\_PACKAGE\_ath10k-firmware-qca9888=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ath10k-firmware-qca988x=y/CONFIG\_PACKAGE\_ath10k-firmware-qca988x=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_ath10k-firmware-qca9984=y/CONFIG\_PACKAGE\_ath10k-firmware-qca9984=n/' .config

# sed -i 's/CONFIG\_PACKAGE\_iw=y/CONFIG\_PACKAGE\_iw=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_iwinfo=y/CONFIG\_PACKAGE\_iwinfo=n/' .config  
# sed -i 's/CONFIG\_PACKAGE\_kmod-iwlwifi=y/CONFIG\_PACKAGE\_kmod-iwlwifi=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_iwlwifi-firmware-ax101=y/CONFIG\_PACKAGE\_iwlwifi-firmware-ax101=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_iwlwifi-firmware-ax200=y/CONFIG\_PACKAGE\_iwlwifi-firmware-ax200=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_iwlwifi-firmware-ax201=y/CONFIG\_PACKAGE\_iwlwifi-firmware-ax201=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_iwlwifi-firmware-ax210=y/CONFIG\_PACKAGE\_iwlwifi-firmware-ax210=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_iwlwifi-firmware-ax211=y/CONFIG\_PACKAGE\_iwlwifi-firmware-ax211=n/' .config

# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8192c-common=y/CONFIG\_PACKAGE\_kmod-rtl8192c-common=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8192cu=y/CONFIG\_PACKAGE\_kmod-rtl8192cu=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8192de=y/CONFIG\_PACKAGE\_kmod-rtl8192de=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8192se=y/CONFIG\_PACKAGE\_kmod-rtl8192se=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8812au-ct=y/CONFIG\_PACKAGE\_kmod-rtl8812au-ct=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8821ae=y/CONFIG\_PACKAGE\_kmod-rtl8821ae=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtl8xxxu=y/CONFIG\_PACKAGE\_kmod-rtl8xxxu=n/' .config  
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtlwifi=y/CONFIG\_PACKAGE\_kmod-rtlwifi=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtlwifi-btcoexist=y/CONFIG\_PACKAGE\_kmod-rtlwifi-btcoexist=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtlwifi-pci=y/CONFIG\_PACKAGE\_kmod-rtlwifi-pci=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtlwifi-usb=y/CONFIG\_PACKAGE\_kmod-rtlwifi-usb=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_kmod-rtw88=y/CONFIG\_PACKAGE\_kmod-rtw88=n/' .config

# # 移除 uhttpd
# sed -i 's/CONFIG\_PACKAGE\_uhttpd=y/CONFIG\_PACKAGE\_uhttpd=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_uhttpd-mod-ubus=y/CONFIG\_PACKAGE\_uhttpd-mod-ubus=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_libiwinfo-lua=y/CONFIG\_PACKAGE\_libiwinfo-lua=n/' .config
# sed -i 's/CONFIG\_PACKAGE\_luci-ssl-openssl=y/CONFIG\_PACKAGE\_luci-ssl-openssl=n/' .config

# 移除 bootstrap 主题
sed -i 's/CONFIG\_PACKAGE\_luci-theme-bootstrap=y/CONFIG\_PACKAGE\_luci-theme-bootstrap=n/' .config

# 解决rust编译错误（\`llvm.download-ci-llvm\` cannot be set to \`true\` on CI. Use \`if-unchanged\` instead.）
echo "------------"
find -name rust
ls feeds/packages/lang/rust
echo "------------"
ls package/feeds/packages/rust
echo "------------"
cat feeds/packages/lang/rust/Makefile
echo "------------"
sed -i 's/--set=llvm.download-ci-llvm=true/--set=llvm.download-ci-llvm=if-unchanged/' feeds/packages/lang/rust/Makefile
echo "------------"
cat feeds/packages/lang/rust/Makefile
echo "------------"

# 添加第三方应用
mkdir kiddin9
pushd kiddin9
git clone --depth=1 https://github.com/kiddin9/kwrt-packages .
popd

mkdir Modem-Support
pushd Modem-Support
git clone --depth=1 https://github.com/Siriling/5G-Modem-Support .
popd

mkdir MyConfig
pushd MyConfig
git clone --depth=1 https://github.com/Siriling/OpenWRT-MyConfig .
popd

mkdir package/community
pushd package/community

# 系统相关应用
#Cpufreq（conf已有）
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-cpufreq
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-lib-mac-vendor
#Fan（conf已有）
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fan
#Poweroff（iStoreOS已有）
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-poweroff
#Diskman（conf已有）
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-diskman
#Fileassistant（iStoreOS已有）
#svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant
#Guest-wifi
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-guest-wifi
mkdir luci-app-guest-wifi
cp -rf ../../kiddin9/luci-app-guest-wifi/\* luci-app-guest-wifi
#Onliner
mkdir luci-app-onliner
cp -rf ../../kiddin9/luci-app-onliner/\* luci-app-onliner
#Eqos（iStoreOS已有）
#svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos
#Wolplus（已有Wol）
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-wolplus
#WiFischedule
# mkdir luci-app-wifischedule
# cp -rf ../../kiddin9/luci-app-wifischedule/\* luci-app-wifischedule
#RAMfree
mkdir luci-app-ramfree
cp -rf ../../kiddin9/luci-app-ramfree/\* luci-app-ramfree
#ttyd（conf已有）
# mkdir luci-app-ttyd
# cp -rf ../kiddin9/luci-app-ttyd/\* luci-app-ttyd
#usb3disable（禁用USB3.0接口）
# mkdir luci-app-usb3disable
# cp -rf ../../kiddin9/luci-app-usb3disable/\* luci-app-usb3disable
#NetData（系统监控）
mkdir luci-app-netdata
cp -rf ../../kiddin9/luci-app-netdata/\* luci-app-netdata
#rtbwmon（实施流量）
mkdir luci-app-rtbwmon
cp -rf ../../kiddin9/luci-app-rtbwmon/\* luci-app-rtbwmon

# 存储相关应用
# Gowebdav（iStoreOS已有）
# svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-gowebdav

# 科学上网和代理应用
#SSR
# svn export https://github.com/fw876/helloworld/trunk helloworld
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ssr-plus
# mkdir luci-app-ssr-plus
# cp -rf ../../kiddin9/luci-app-ssr-plus/\* luci-app-ssr-plus
# cp -rf ../../kiddin9/dns2socks/\* dns2socks
# cp -rf ../../kiddin9/lua-neturl/\* lua-neturl
# cp -rf ../../kiddin9/microsocks/\* microsocks
# cp -rf ../../kiddin9/tcping/\* tcping
# cp -rf ../../kiddin9/shadowsocksr-libev/\* shadowsocksr-libev
# cp -rf ../../kiddin9/chinadns-ng/\* chinadns-ng
# cp -rf ../../kiddin9/mosdns/\* mosdns
# cp -rf ../../kiddin9/hysteria/\* hysteria
# cp -rf ../../kiddin9/tuic-client/\* tuic-client
# cp -rf ../../kiddin9/shadow-tls/\* shadow-tls
# cp -rf ../../kiddin9/ipt2socks/\* ipt2socks
# cp -rf ../../kiddin9/naiveproxy/\* naiveproxy
# cp -rf ../../kiddin9/redsocks2/\* redsocks2
# cp -rf ../../kiddin9/shadowsocks-rust/\* shadowsocks-rust
# cp -rf ../../kiddin9/simple-obfs/\* simple-obfs
# cp -rf ../../kiddin9/v2ray-plugin/\* v2ray-plugin
# cp -rf ../../kiddin9/trojan/\* trojan
#Passwall和Passwall2
# svn export https://github.com/xiaorouji/openwrt-passwall/trunk openwrt-passwall
# svn export https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall
# svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2
#VSSR（Hello Word）
# svn export https://github.com/jerrykuku/lua-maxminddb/trunk lua-maxminddb
# svn export https://github.com/jerrykuku/luci-app-vssr/trunk luci-app-vssr
if \[ "$1" = "istoreos-22.03" \]; then
    #OpenClash
    mkdir luci-app-openclash
    cp -rf ../../kiddin9/luci-app-openclash/\* luci-app-openclash
    cp -rf ../../MyConfig/configs/istoreos/general/applications/luci-app-openclash/\* luci-app-openclash
fi
#加入OpenClash核心
chmod -R a+x $GITHUB\_WORKSPACE/scripts/preset-clash-core.sh
if \[ "$2" = "rk33xx" \] || \[ "$2" = "rk33xx-23.05" \] || \[ "$2" = "rk33xx-24.10" \]; then
    $GITHUB\_WORKSPACE/scripts/preset-clash-core.sh arm64
elif \[ "$2" = "rk35xx" \] || \[ "$2" = "rk35xx-23.05" \] || \[ "$2" = "rk35xx-24.10" \]; then
    $GITHUB\_WORKSPACE/scripts/preset-clash-core.sh arm64
elif \[ "$2" = "x86" \] || \[ "$2" = "x86-23.05" \] || \[ "$2" = "x86-24.10" \]; then
    $GITHUB\_WORKSPACE/scripts/preset-clash-core.sh amd64
fi

# 去广告
#ADGuardHome（kiddin9）
mkdir luci-app-adguardhome
cp -rf ../../kiddin9/luci-app-adguardhome/\* luci-app-adguardhome
cp -rf ../../MyConfig/configs/istoreos/general/applications/luci-app-adguardhome/\* luci-app-adguardhome
sed -i 's/拦截DNS服务器/拦截DNS服务器（默认用户名和密码均为root）/' luci-app-adguardhome/po/zh\_Hans/adguardhome.po
#sed -i 's/+PACKAGE\_$(PKG\_NAME)\_INCLUDE\_binary:adguardhome//' luci-app-adguardhome/Makefile
#ADGuardHome（kenzok8）
# svn export https://github.com/kenzok8/openwrt-packages/trunk/adguardhome
# svn export https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome
# svn export https://github.com/Siriling/OpenWRT-MyConfig/trunk/configs/lede/general/applications/luci-app-adguardhome temp/luci-app-adguardhome
# cp -rf temp/luci-app-adguardhome/\* luci-app-adguardhome
# sed -i 's/默认账号和密码均为：admin/默认用户名和密码均为root/' luci-app-adguardhome/po/zh-cn/AdGuardHome.po
# sed -i 's/网页管理账号和密码:admin ,端口:/端口/' luci-app-adguardhome/po/zh-cn/AdGuardHome.po
#dnsfilter
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-dnsfilter
#ikoolproxy
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-ikoolproxy

# docker应用
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-filebrowser
# rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-kodexplorer
# rm -rf ../../customfeeds/packages/utils/verysync
# rm -rf ../../customfeeds/luci/applications/luci-app-verysync
# svn export https://github.com/kenzok8/small-package/trunk/verysync
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-verysync

# VPN服务器
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-ssr-mudb-server
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-ipsec-server
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-pptp-server
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-softethervpn

# DNS
# svn export https://github.com/kenzok8/small-package/trunk/mosdns
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-mosdns
# svn export https://github.com/kenzok8/small-package/trunk/smartdns
# svn export https://github.com/kenzok8/small-package/trunk/luci-app-smartdns

#内网穿透
#Zerotier（iStoreOS已有）
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-zerotier

# 其他
#Socat（iStoreOS已有）
#svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-socat
#Unblockneteasemusic
# mkdir UnblockNeteaseMusic
# mkdir luci-app-unblockneteasemusic
# cp -rf ../../kiddin9/UnblockNeteaseMusic/\* UnblockNeteaseMusic
# cp -rf ../../kiddin9/luci-app-unblockneteasemusic/\* luci-app-unblockneteasemusic
#OpenAppFilter（conf已有）
# svn export https://github.com/destan19/OpenAppFilter/trunk OpenAppFilter

# 5G通信模组拨号工具
mkdir quectel\_QMI\_WWAN
# mkdir fibocom\_QMI\_WWAN
# mkdir meig\_QMI\_WWAN
# mkdir tw\_QMI\_WWAN
mkdir quectel\_cm\_5G
mkdir quectel\_MHI
# mkdir luci-app-hypermodem
cp -rf ../../Modem-Support/quectel\_QMI\_WWAN/\* quectel\_QMI\_WWAN
# cp -rf ../../Modem-Support/fibocom\_QMI\_WWAN/\* fibocom\_QMI\_WWAN
# cp -rf ../../Modem-Support/meig\_QMI\_WWAN/\* meig\_QMI\_WWAN
# cp -rf ../../Modem-Support/tw\_QMI\_WWAN/\* tw\_QMI\_WWAN
cp -rf ../../Modem-Support/quectel\_cm\_5G/\* quectel\_cm\_5G
cp -rf ../../Modem-Support/quectel\_MHI/\* quectel\_MHI
# cp -rf ../../Modem-Support/luci-app-hypermodem/\* luci-app-hypermodem

# 5G模组短信插件
# cp -rf temp/luci-app-sms-tool/\* luci-app-sms-tool
mkdir sms-tool
mkdir luci-app-sms-tool
cp -rf ../../Modem-Support/sms-tool/\* sms-tool
cp -rf ../../Modem-Support/luci-app-sms-tool/\* luci-app-sms-tool
cp -rf ../../MyConfig/configs/istoreos/general/applications/luci-app-sms-tool/\* luci-app-sms-tool

# 5G模组信息插件
# svn export https://github.com/qiuweichao/luci-app-modem-info/trunk/luci-app-3ginfo-lite
# svn export https://github.com/owner888/luci-app-3ginfo-zh\_cn/trunk/3ginfo
# svn export https://github.com/owner888/luci-app-3ginfo-zh\_cn/trunk/luci-app-3ginfo

# 5G模组IPv6
mkdir ndisc
cp -rf ../../Modem-Support/ndisc/\* ndisc

# 5G模组信息插件+AT工具
mkdir luci-app-modem
cp -rf ../../Modem-Support/luci-app-modem/\* luci-app-modem
rm -rf ../../Modem-Support/luci-app-modem/po/zh\_Hans #解决汉化问题
popd

# 5G模组拨号脚本
# mkdir -p package/base-files/files/root/5GModem
# cp -rf $GITHUB\_WORKSPACE/tools/5G模组拨号脚本/5GModem/\* package/base-files/files/root/5GModem
# echo -e "#\* \* \* \* \* bash /root/5GModem/5g\_crontab.sh" >> package/istoreos-files/files/etc/crontabs/root

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

# 添加第三方应用
# 系统相关应用
echo "
CONFIG\_PACKAGE\_luci-app-poweroff=y
CONFIG\_PACKAGE\_luci-app-fileassistant=y
# CONFIG\_PACKAGE\_luci-app-guest-wifi=y
CONFIG\_PACKAGE\_luci-app-onliner=y
CONFIG\_PACKAGE\_luci-app-eqos=y
# CONFIG\_PACKAGE\_luci-app-wolplus=y
# CONFIG\_PACKAGE\_luci-app-wifischedule=y
CONFIG\_PACKAGE\_luci-app-ramfree=y
# CONFIG\_PACKAGE\_luci-app-usb3disable=y
CONFIG\_PACKAGE\_luci-app-luci-app-netdata=y
CONFIG\_PACKAGE\_luci-app-luci-app-rtbwmon=y
" >> .config

# 存储相关应用
echo "
# CONFIG\_PACKAGE\_luci-app-gowebdav=y
" >> .config

# 科学上网和代理应用
echo "
#SSR
# CONFIG\_PACKAGE\_luci-app-ssr-plus=y
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_NONE\_Client=y
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_Libev\_Client is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_Rust\_Client is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_NONE\_Server=y
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_Libev\_Server is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_Rust\_Server is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_NONE\_V2RAY is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_V2ray is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Xray=y
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_ChinaDNS\_NG is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_MosDNS=n
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Hysteria is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Tuic\_Client is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadow\_TLS is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_IPT2Socks is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Kcptun is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_NaiveProxy is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Redsocks2 is not set
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_Simple\_Obfs=n
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Shadowsocks\_V2ray\_Plugin=n
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_ShadowsocksR\_Libev\_Client=n
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_ShadowsocksR\_Libev\_Server=n
# CONFIG\_PACKAGE\_luci-app-ssr-plus\_INCLUDE\_Trojan is not set

#Passwall和Passwall2
# CONFIG\_PACKAGE\_luci-app-passwall2=y
# CONFIG\_PACKAGE\_luci-app-passwall=y
# CONFIG\_PACKAGE\_luci-app-passwall\_Transparent\_Proxy=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Brook=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_ChinaDNS\_NG=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Haproxy=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Hysteria=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_IPv6\_Nat=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Kcptun=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_NaiveProxy=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Shadowsocks\_Libev\_Client=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Shadowsocks\_Libev\_Server=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Shadowsocks\_Rust\_Client=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Shadowsocks\_Rust\_Server=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_ShadowsocksR\_Libev\_Client=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_ShadowsocksR\_Libev\_Server=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Simple\_Obfs=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_SingBox=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Trojan\_GO=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Trojan\_Plus=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_V2ray=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_V2ray\_Plugin=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Xray=y
# CONFIG\_PACKAGE\_luci-app-passwall\_INCLUDE\_Xray\_Plugin=y
# CONFIG\_PACKAGE\_luci-app-haproxy-tcp=y

#VSSR（HelloWord）
# CONFIG\_PACKAGE\_luci-app-vssr=y
# CONFIG\_PACKAGE\_luci-app-vssr\_INCLUDE\_Xray=y
# CONFIG\_PACKAGE\_luci-app-vssr\_INCLUDE\_Trojan=y
# CONFIG\_PACKAGE\_luci-app-vssr\_INCLUDE\_Kcptun=y
# CONFIG\_PACKAGE\_luci-app-vssr\_INCLUDE\_Xray\_plugin=y
# CONFIG\_PACKAGE\_luci-app-vssr\_INCLUDE\_ShadowsocksR\_Server=y

#Openclash
CONFIG\_PACKAGE\_luci-app-openclash=y
" >> .config

# 去广告应用
echo "
# CONFIG\_PACKAGE\_luci-app-adguardhome=y
# CONFIG\_PACKAGE\_luci-app-dnsfilter=y
# CONFIG\_PACKAGE\_luci-app-ikoolproxy=y
" >> .config

# docker应用
echo "
# CONFIG\_PACKAGE\_luci-app-aliyundrive-webdav=y
# CONFIG\_PACKAGE\_luci-app-aria2=y
# CONFIG\_PACKAGE\_luci-app-transmission=y
# CONFIG\_PACKAGE\_luci-app-qbittorrent=y
# CONFIG\_PACKAGE\_luci-app-qbittorrent\_static=y
# CONFIG\_PACKAGE\_luci-app-alist=y
# CONFIG\_PACKAGE\_luci-app-filebrowser=y
# CONFIG\_PACKAGE\_luci-app-familycloud=y
# CONFIG\_PACKAGE\_luci-app-kodexplorer=y
# CONFIG\_PACKAGE\_luci-app-rclone=y
" >> .config

# 局域网分享应用
echo "
# CONFIG\_PACKAGE\_luci-app-minidlna=y
# CONFIG\_PACKAGE\_luci-app-airplay2=y
# CONFIG\_PACKAGE\_luci-app-shairplay=y
# CONFIG\_PACKAGE\_luci-app-music-remote-center=y
# CONFIG\_PACKAGE\_luci-app-mjpg-streamer=y
# CONFIG\_PACKAGE\_luci-app-ps3netsrv=y
# CONFIG\_PACKAGE\_luci-app-usb-printer=y
" >> .config

# VPN服务器
echo "
# CONFIG\_PACKAGE\_luci-app-brook-server=y
# CONFIG\_PACKAGE\_luci-app-ssr-mudb-server=y
# CONFIG\_PACKAGE\_luci-app-trojan-server=y
# CONFIG\_PACKAGE\_luci-app-openvpn-server=y
# CONFIG\_PACKAGE\_luci-app-pptp-server=y
# CONFIG\_PACKAGE\_luci-app-softethervpn=y
" >> .config

# DNS
echo "
# CONFIG\_PACKAGE\_luci-app-mosdns=y
# CONFIG\_PACKAGE\_luci-app-smartdns=y
" >> .config

# DDNS
echo "
# CONFIG\_PACKAGE\_luci-app-aliddns=y
# CONFIG\_PACKAGE\_luci-app-tencentddns=y
" >> .config


# 内网穿透
echo "
# CONFIG\_PACKAGE\_luci-app-zerotier=y
# CONFIG\_PACKAGE\_luci-app-frpc=y
# CONFIG\_PACKAGE\_luci-app-frps=y
# CONFIG\_PACKAGE\_luci-app-nps=y
# CONFIG\_PACKAGE\_luci-app-n2n\_v2=y
" >> .config

# 其他
echo "
# CONFIG\_PACKAGE\_luci-app-pushbot=y
CONFIG\_PACKAGE\_luci-app-socat=y
# CONFIG\_PACKAGE\_luci-app-unblockneteasemusic=y
# CONFIG\_PACKAGE\_luci-app-uugamebooster=y
# CONFIG\_PACKAGE\_luci-app-xlnetacc=y
# CONFIG\_PACKAGE\_luci-udptools=y
" >> .config

#补充网卡
echo "
CONFIG\_PACKAGE\_kmod-mt7922-firmware=y
CONFIG\_PACKAGE\_kmod-ath=y
CONFIG\_PACKAGE\_kmod-ath10k=y
CONFIG\_PACKAGE\_ath10k-board-qca9888=y
CONFIG\_PACKAGE\_ath10k-board-qca988x=y
CONFIG\_PACKAGE\_ath10k-board-qca9984=y
CONFIG\_PACKAGE\_ath10k-firmware-qca9888=y
CONFIG\_PACKAGE\_ath10k-firmware-qca988x=y
CONFIG\_PACKAGE\_ath10k-firmware-qca9984=y
" >> .config

#5G相关
echo "
# 5G模组信号插件
# CONFIG\_PACKAGE\_ext-rooter-basic=y

# 5G模组短信插件
CONFIG\_PACKAGE\_luci-app-sms-tool=y

# 5G模组信息插件
# CONFIG\_PACKAGE\_luci-app-3ginfo-lite=y
# CONFIG\_PACKAGE\_luci-app-3ginfo=y

# 5G模组信息插件+AT工具
# CONFIG\_PACKAGE\_luci-app-cpe=y
# CONFIG\_PACKAGE\_sendat=y
CONFIG\_PACKAGE\_sms-tool=y
CONFIG\_PACKAGE\_luci-app-modem=y
CONFIG\_PACKAGE\_kmod-qmi\_wwan\_q=y
# CONFIG\_PACKAGE\_kmod-qmi\_wwan\_f=y
# CONFIG\_PACKAGE\_kmod-qmi\_wwan\_m=y
# CONFIG\_PACKAGE\_kmod-qmi\_wwan\_t=y

# QMI拨号工具（移远，广和通）
# CONFIG\_PACKAGE\_quectel-CM-5G=y
# CONFIG\_PACKAGE\_fibocom-dial=y

# QMI拨号软件
# CONFIG\_PACKAGE\_luci-app-hypermodem=y

# Gobinet拨号软件
# CONFIG\_PACKAGE\_kmod-gobinet=y
# CONFIG\_PACKAGE\_luci-app-gobinetmodem=y

# 串口调试工具
CONFIG\_PACKAGE\_minicom=y

# 脚本拨号工具依赖
CONFIG\_PACKAGE\_procps-ng=y
CONFIG\_PACKAGE\_procps-ng-ps=y
" >> .config

# =====================================================
# xgp-v3 追加配置 - QModem + 屏幕驱动
# =====================================================
echo "
# =====================================================
# xgp-v3 追加配置 - QModem + 屏幕驱动
# 生成时间: 2026-04-23
# =====================================================

# -------------------- QModem 5G模组管理 --------------------
CONFIG\_PACKAGE\_luci-app-qmodem=y
CONFIG\_PACKAGE\_luci-app-qmodem-sms=y
CONFIG\_PACKAGE\_luci-app-qmodem-mwan=y
CONFIG\_PACKAGE\_luci-app-qmodem-ttl=y

# -------------------- xgp-v3 屏幕驱动 --------------------
# Framebuffer TFT 基础框架（必须）
CONFIG\_PACKAGE\_kmod-fb-tft=y
CONFIG\_PACKAGE\_kmod-fb-tft-gc9307=y

# xgp-v3 屏幕控制程序
CONFIG\_PACKAGE\_xgp-v3-screen=y

# -------------------- 屏幕驱动依赖 --------------------
CONFIG\_PACKAGE\_libpthread=y
CONFIG\_PACKAGE\_libstdcpp=y
CONFIG\_PACKAGE\_python3=y

# =====================================================
# 配置结束
# =====================================================
" >> .config

# 额外组件
echo "
CONFIG\_GRUB\_IMAGES=y
CONFIG\_VMDK\_IMAGES=y
" >> .config

# 复制 xgpv3 设备树
cp -f $GITHUB\_WORKSPACE/configs/rk3568-xiguapi-v3.dts \\
  $WORKDIR/target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/

echo "============================================"
echo "✅ 编译配置完成!"
echo "✅ 已添加: QModem + xgp-v3 屏幕驱动"
echo "============================================"

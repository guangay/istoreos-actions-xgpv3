#!/bin/bash
# =====================================================================
# diy-part2.sh - 内核配置与软件包配置（含屏幕驱动 + QModem）
# 按照 immortalwrt 官方规范配置 xgpv3
# =====================================================================

echo "=== 执行 diy-part2.sh ==="

# 自动检测 openwrt 目录
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
add_config() {
    local key="$1"
    local value="$2"
    if ! grep -q "^${key}=" .config 2>/dev/null; then
        echo "${key}=${value}" >> .config
    fi
}

disable_config() {
    local key="$1"
    if ! grep -q "^# ${key} is not set" .config 2>/dev/null; then
        echo "# ${key} is not set" >> .config
    fi
}

# =====================================================================
# 目标设备配置（immortalwrt 官方规范）
# =====================================================================
echo ">>> 配置目标设备..."

# 基础目标配置
add_config CONFIG_TARGET_rockchip y
add_config CONFIG_TARGET_rockchip_armv8 y
add_config CONFIG_TARGET_MULTI_PROFILE y
add_config CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3 y
add_config CONFIG_TARGET_BOARD "rockchip"
add_config CONFIG_TARGET_SUBTARGET "armv8"
add_config CONFIG_TARGET_PROFILE "DEVICE_nlnet_xgpv3"

# =====================================================================
# 设备树文件（按 immortalwrt 官方规范放置）
# =====================================================================
echo ">>> 配置设备树文件..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 设备树源路径（用户仓库中的位置）
DTS_SOURCE="$SCRIPT_DIR/target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-xiguapi-v3.dts"

if [ -f "$DTS_SOURCE" ]; then
    mkdir -p target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
    cp -f "$DTS_SOURCE" target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
    # 同时复制到 uboot 目录
    mkdir -p package/boot/uboot-rockchip/files/arch/arm64/boot/dts/rockchip/
    cp -f "$DTS_SOURCE" package/boot/uboot-rockchip/files/arch/arm64/boot/dts/rockchip/
    echo "✅ 设备树已复制"
else
    echo "⚠️ 设备树文件不存在: $DTS_SOURCE"
    # 尝试其他可能的位置
    for alt_path in \
        "$SCRIPT_DIR/target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-xiguapi-v3.dts"; do
        if [ -f "$alt_path" ]; then
            echo ">>> 找到替代设备树: $alt_path"
            mkdir -p target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
            cp -f "$alt_path" target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
            mkdir -p package/boot/uboot-rockchip/files/arch/arm64/boot/dts/rockchip/
            cp -f "$alt_path" package/boot/uboot-rockchip/files/arch/arm64/boot/dts/rockchip/
            echo "✅ 设备树已复制"
            break
        fi
    done
fi

# =====================================================================
# 设备特定配置（immortalwrt 官方 armv8.mk 规范）
# =====================================================================
echo ">>> 应用 armv8.mk 设备配置..."

ARMV8_MK=""
for path in \
    "$SCRIPT_DIR/target/linux/rockchip/image/armv8.mk" \
    "$SCRIPT_DIR/target/linux/rockchip/armv8.mk"; do
    if [ -f "$path" ]; then
        ARMV8_MK="$path"
        break
    fi
done

if [ -n "$ARMV8_MK" ]; then
    mkdir -p target/linux/rockchip
    cp -f "$ARMV8_MK" target/linux/rockchip/armv8.mk
    echo "✅ armv8.mk 已应用"
else
    echo "⚠️ armv8.mk 不存在，跳过"
fi

# =====================================================================
# 应用补丁（TD-TECH option id）
# =====================================================================
echo ">>> 应用补丁..."

PATCH_FILE=""
for path in \
    "$SCRIPT_DIR/999-add-TD-TECH-option-id.patch" \
    "$SCRIPT_DIR/patches/999-add-TD-TECH-option-id.patch" \
    "$SCRIPT_DIR/target/linux/rockchip/999-add-TD-TECH-option-id.patch"; do
    if [ -f "$path" ]; then
        PATCH_FILE="$path"
        break
    fi
done

if [ -n "$PATCH_FILE" ]; then
    patch -p1 -i "$PATCH_FILE" || echo "⚠️ 补丁应用失败，继续..."
    echo "✅ 补丁已应用"
else
    echo "⚠️ 补丁文件不存在，跳过"
fi

# =====================================================================
# 屏幕驱动（xgp-v3-screen）
# =====================================================================
echo ">>> 配置屏幕驱动..."

# 优先使用用户仓库中的驱动
SCREEN_LOCAL="$SCRIPT_DIR/xgp-v3-screen"
SCREEN_PKG="package/xgp-v3-screen"

if [ -d "$SCREEN_LOCAL" ]; then
    rm -rf "$SCREEN_PKG"
    cp -r "$SCREEN_LOCAL" "$SCREEN_PKG"
    echo "✅ 使用本地 xgp-v3-screen"
elif [ -d "$SCREEN_PKG" ]; then
    echo "✅ xgp-v3-screen 已存在"
else
    # 从 GitHub 克隆
    git clone --depth 1 https://github.com/junhong-l/xgp-v3-screen.git "$SCREEN_PKG"
    echo "✅ xgp-v3-screen 已克隆"
fi

# =====================================================================
# QModem 支持（4G/5G 模块管理）
# =====================================================================
echo ">>> 配置 QModem..."

QMODEM_LOCAL="$SCRIPT_DIR/QModem"
QMODEM_PKG="package/QModem"

if [ -d "$QMODEM_LOCAL" ]; then
    rm -rf "$QMODEM_PKG"
    cp -r "$QMODEM_LOCAL" "$QMODEM_PKG"
    echo "✅ 使用本地 QModem"
elif [ -d "$QMODEM_PKG" ]; then
    echo "✅ QModem 已存在"
else
    # 从 GitHub 克隆
    git clone --depth 1 https://github.com/FUjr/QModem.git "$QMODEM_PKG"
    echo "✅ QModem 已克隆"
fi

# 根据 QModem 需要，添加常用依赖包（可根据实际需求调整）
add_config CONFIG_PACKAGE_qmi y
add_config CONFIG_PACKAGE_uqmi y
add_config CONFIG_PACKAGE_modemmanager y
add_config CONFIG_PACKAGE_libqmi y
add_config CONFIG_PACKAGE_libmbim y

# =====================================================================
# 基本系统配置
# =====================================================================
echo ">>> 配置基本系统..."

# IPv6 支持
add_config CONFIG_IPV6 y

# 禁用 third_party（按要求）
disable_config CONFIG_PACKAGE_third_party

# =====================================================================
# 编译前验证
# =====================================================================
echo ">>> 验证设备配置..."

# 确保设备配置存在
DEVICE_CONFIG="CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_nlnet_xgpv3=y"
if ! grep -q "^${DEVICE_CONFIG}" .config 2>/dev/null; then
    echo "⚠️ 设备配置丢失，强制添加..."
    echo "$DEVICE_CONFIG" >> .config
fi

make defconfig
echo "✅ 配置已更新 ($(wc -l < .config) 行)"

echo "=== diy-part2.sh 执行完成 ==="

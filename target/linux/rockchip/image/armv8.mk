define Device/nlnet_xiguapi-v3
  $(Device/rk3568)
  DEVICE_VENDOR := NLnet
  DEVICE_MODEL := XiGuaPi V3
  DEVICE_PACKAGES := kmod-hwmon-pwmfan kmod-input-adc-keys kmod-saradc-rockchip
endef
TARGET_DEVICES += nlnet_xiguapi-v3

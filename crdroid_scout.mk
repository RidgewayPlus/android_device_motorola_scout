#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from scout device
$(call inherit-product, device/motorola/scout/device.mk)

# Inherit some common crDroid stuff.
# Note: crDroid maps the vendor/lineage path to crdroidandroid/android_vendor_crdroid,
# so this resolves to crDroid's config, not LineageOS's.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_DEVICE := scout
PRODUCT_NAME := crdroid_scout
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola edge 60 fusion
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="scout_g_sys-user 16 W1VCS36M.14-20-19-7 45d3dc release-keys" \
    BuildFingerprint=motorola/scout_g_sys/scout:16/W1VCS36M.14-20-19-7/45d3dc:user/release-keys

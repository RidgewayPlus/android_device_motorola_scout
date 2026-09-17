#
# Copyright (C) The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
BUILD_BROKEN_DUP_RULES := true
DEVICE_PATH := device/motorola/scout

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    system \
    system_dlkm \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    vendor_boot \
    vbmeta \
    vbmeta_system

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55

# Force any prefer32 targets to be compiled as 64 bit.
IGNORE_PREFER32_ON_DEVICE := true

# Include 64-bit drmserver to support 64-bit only devices
TARGET_DYNAMIC_64_32_DRMSERVER := true

# Include 64-bit mediaserver to support 64-bit only devices
TARGET_DYNAMIC_64_32_MEDIASERVER := true

# Enable 64-bit for non-zygote.
ZYGOTE_FORCE_64 := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := scout
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 450

# HIDL
DEVICE_MANIFEST_FILE += \
    $(DEVICE_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE += $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/mediatek/vintf/mediatek_framework_compatibility_matrix.xml \
    $(DEVICE_PATH)/configs/vintf/framework_compatibility_matrix.xml

# Fastboot
TARGET_BOARD_FASTBOOT_INFO_FILE := $(DEVICE_PATH)/fastboot-info.txt

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/configs/mot_aids.fs

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/init/fstab.mt6878
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_USERIMAGES_USE_F2FS := true

# Kernel
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_OFFSET := 0x00000000
BOARD_KERNEL_PAGESIZE := 0x00001000
BOARD_TAGS_OFFSET := 0x07c80000
BOARD_RAMDISK_OFFSET := 0x26f00000
BOARD_BOOT_HEADER_VERSION := 4
BOARD_INIT_BOOT_HEADER_VERSION := 4

BOARD_RAMDISK_USE_LZ4 := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_KERNEL_IMAGE_NAME := Image.gz

BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=11201000.usb0

TARGET_FORCE_PREBUILT_KERNEL := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)-kernel/dtb
PRODUCT_COPY_FILES += \
	$(DEVICE_PATH)-kernel/Image.gz:kernel

BOARD_SYSTEM_KERNEL_MODULES := $(wildcard $(DEVICE_PATH)-kernel/system/*.ko)
BOARD_SYSTEM_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)-kernel/modules.load.system))
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(DEVICE_PATH)-kernel/vendor/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)-kernel/modules.load.vendor))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(DEVICE_PATH)-kernel/vendor_ramdisk/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)-kernel/modules.load.vendor_ramdisk))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)-kernel/modules.load.recovery))
BOOT_KERNEL_MODULES := $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD)

# Recovery touch modules (from vendor_dlkm)
RECOVERY_KERNEL_MODULES := \
    mmi_info \
    mmi_relay \
    sensors_class \
    touchscreen_u_mmi \
    focaltech_touch_v3_u_mmi

BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(addprefix $(DEVICE_PATH)-kernel/vendor/,$(addsuffix .ko,$(RECOVERY_KERNEL_MODULES)))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD += $(RECOVERY_KERNEL_MODULES)

BOARD_MKBOOTIMG_ARGS += \
    --dtb_offset $(BOARD_TAGS_OFFSET) \
    --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --kernel_offset $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_TAGS_OFFSET)

BOARD_MKBOOTIMG_INIT_ARGS += \
    --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)

TARGET_NO_KERNEL_OVERRIDE := true
# Unsets INLINE_KERNEL_BUILDING in envsetup. Without this, soong still runs
# generated_kernel_includes against kernel/motorola/scout, which does not exist
# (the kernel is reconstructed from stock firmware).
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)-kernel/Image.gz
# UAPI tarball built from bionic/libc/kernel/uapi (GKI 6.1 layout). Stops
# vendor/lineage/build/soong from calling `make headers_install` in a missing
# kernel tree, and gives cc.go prebuilt_kernel_headers instead.
TARGET_PREBUILT_KERNEL_HEADERS := $(DEVICE_PATH)-kernel/kernel-uapi-headers.tar.gz

# Partitions
BOARD_PRODUCTIMAGE_MINIMAL_PARTITION_RESERVED_SIZE := false
-include vendor/lineage/config/BoardConfigReservedSize.mk
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_EROFS_PCLUSTER_SIZE := 65536
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_SUPER_PARTITION_SIZE := 16508780544
BOARD_SUPER_PARTITION_GROUPS := motorola_dynamic_partitions
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_dlkm system_ext vendor vendor_dlkm product
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_SIZE := 16506683392

BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_ODM := vendor/odm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

BOARD_USES_METADATA_PARTITION := true

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/configs/props/product.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/configs/props/vendor.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/configs/props/system.prop
TARGET_ODM_PROP += $(DEVICE_PATH)/configs/props/odm.prop

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
BOOT_SECURITY_PATCH := 2025-08-01
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Sepolicy
include device/mediatek/sepolicy_vndr/SEPolicy.mk
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/basic/non_plat
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public

# Udfps
TARGET_USES_FOD_ZPOS := true
$(call soong_config_set,surfaceflinger,udfps_lib,//device/motorola/scout/udfps:libudfps_extension.scout)

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_ROLLBACK_INDEX := 18

BOARD_AVB_VBMETA_SYSTEM := system product system_ext
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := $(BOARD_AVB_ALGORITHM)
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(BOARD_AVB_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 18
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# Wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_DRIVER_FW_PATH_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_FW_PATH_STA := "STA"
WIFI_DRIVER_FW_PATH_AP := "AP"
WIFI_DRIVER_FW_PATH_P2P := "P2P"
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_STATE_ON := "1"
WIFI_DRIVER_STATE_OFF := "0"
WIFI_HAL_INTERFACE_COMBINATIONS := {{{STA}, 2}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{AP}, 2},}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{AP}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{P2P}, 1}}
WIFI_HAL_INTERFACE_COMBINATIONS += ,{{{STA}, 1}, {{NAN}, 1}}
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

# Inherit the proprietary files
include vendor/motorola/scout/BoardConfigVendor.mk
include vendor/motorola/scout-motcamera/BoardConfigVendor.mk

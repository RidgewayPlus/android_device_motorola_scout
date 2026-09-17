#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/scout',
    'hardware/mediatek/libmtkperf_client',
    'hardware/mediatek',
    'hardware/motorola',
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    ('vendor.mediatek.hardware.videotelephony@1.0',): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/etc/init/android.hardware.neuralnetworks-shim-service-mtk.rc': blob_fixup()
        .regex_replace('start', 'enable'),

    'vendor/bin/hw/android.hardware.media.c2@1.2-mediatek-64b': blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libavservices_minijail_vendor.so', 'libavservices_minijail.so'),

    ('vendor/bin/mnld', 'vendor/lib64/hw/android.hardware.sensors@2.X-subhal-mediatek.so', 'vendor/lib64/mt6878/libcam.utils.sensorprovider.so'): blob_fixup()
        .add_needed('android.hardware.sensors@1.0-convert-shared.so'),

    'vendor/lib64/hw/audio.primary.mediatek.so': blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libutils.so','libutils-v32.so')
        .replace_needed('libalsautils.so','libalsautils-v31.so'),

    'vendor/lib64/hw/hwcomposer.mtk_common.so': blob_fixup()
        .add_needed('libprocessgroup_shim.so'),

    ('vendor/lib64/mt6878/libneuralnetworks_sl_driver_mtk_prebuilt.so', 
     'vendor/lib64/libstfactory-vendor.so', 'vendor/lib64/libnvram.so',
     'vendor/lib64/libsysenv.so', 'vendor/lib64/libtflite_mtk.so'): blob_fixup()
        .add_needed('libbase_shim.so'),

    ('vendor/lib64/hw/mt6878/android.hardware.camera.provider@2.6-impl-mediatek.so','vendor/lib64/mt6878/libmtkcam_stdutils.so',
     'vendor/lib64/sensors.moto.so'): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .add_needed('libbase_shim.so'),

    'vendor/etc/vintf/manifest/manifest_media_c2_V1_2_default.xml': blob_fixup()
        .regex_replace('1.1', '1.2')
        .regex_replace('@1.0', '@1.2')
        .regex_replace('default9', 'default'),

    ('vendor/lib64/mt6878/lib3a.ae.stat.so','vendor/lib64/mt6878/lib3a.sensors.flicker.so',
     'vendor/lib64/mt6878/lib3a.sensors.color.so'): blob_fixup()
        .add_needed('liblog.so'),

    'vendor/lib64/mt6878/libmnl.so': blob_fixup()
        .add_needed('libcutils.so'),

    'vendor/lib64/mt6878/libmtkcam_hal_aidl_common.so': blob_fixup()
        .replace_needed('android.hardware.camera.common-V2-ndk.so', 'android.hardware.camera.common-V1-ndk.so'),

    'vendor/lib64/vendor.mediatek.hardware.bluetooth.audio-V1-ndk.so': blob_fixup()
        .replace_needed('android.hardware.audio.common-V1-ndk.so', 'android.hardware.audio.common-V2-ndk.so'),

    'vendor/lib64/mt6878/libpqconfig.so': blob_fixup()
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so'),

    ('vendor/lib64/mt6878/lib3a.ae.stat.so',
     'vendor/lib64/libarmnn_ndk.mtk.vndk.so'): blob_fixup()
        .add_needed('liblog.so'),

    # Every stock blob here links android.hardware.graphics.common v4. The
    # platform builds the same interface at v7: hardware/interfaces/graphics/
    # common/aidl freezes only up to v6, and with frozen: false Soong numbers the
    # unfrozen current version max+1 = 7. libui and libgralloctypes link the
    # unversioned android.hardware.graphics.common-ndk_shared, i.e. that v7, so a
    # blob still on v4 or v6 makes any module that links both sides depend on two
    # versions of one aidl_interface, which Soong rejects outright. v4, v6 and v7
    # are all frozen-or-later revisions of one interface, so the ndk libs are
    # additive and rewriting the DT_NEEDED straight to v7 is safe.
    #
    # Retargeting to v7 rather than v6 matters beyond these 14: hwcomposer.mtk_common
    # links pq_aidl-V4, so leaving that blob on v6 handed hwcomposer a v6 edge it
    # never had in stock, clashing with the v7 it inherits via libgralloctypes.
    # These 14 are the only graphics.common linkers in the vendor tree, so moving
    # all of them to v7 removes the version from the tree entirely.
    ('vendor/bin/hw/mt6878/android.hardware.graphics.allocator-V2-service-mediatek.mt6878',
     'vendor/lib64/egl/mt6878/libGLES_mali.so',
     'vendor/lib64/hw/mt6878/android.hardware.graphics.allocator-V2-mediatek.so',
     'vendor/lib64/hw/mt6878/android.hardware.graphics.mapper@4.0-impl-mediatek.so',
     'vendor/lib64/hw/mt6878/mapper.mediatek.so',
     'vendor/lib64/mt6878/libmtkcam_grallocutils.so',
     'vendor/lib64/libcodec2_fsr.so',
     'vendor/lib64/libcodec2_vpp_AIMEMC_plugin.so',
     'vendor/lib64/libcodec2_vpp_AISR_plugin.so',
     'vendor/lib64/libmtkcam_grallocutils_aidlv1helper.so',
     'vendor/lib64/vendor.mediatek.hardware.camera.isphal-V1-ndk.so',
     'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V2-ndk.so',
     'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V4-ndk.so',
     'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V7-ndk.so'): blob_fixup()
        .replace_needed('android.hardware.graphics.common-V4-ndk.so', 'android.hardware.graphics.common-V7-ndk.so')
        .replace_needed('android.hardware.graphics.allocator-V1-ndk.so', 'android.hardware.graphics.allocator-V2-ndk.so'),

    'vendor/lib64/mt6878/libneuralnetworks_sl_driver_mtk_prebuilt.so': blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_createFromHandle')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_getNativeHandle')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_lockPlanes')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),

    'vendor/lib64/hw/mt6878/vendor.mediatek.hardware.pq_aidl-impl.so': blob_fixup()
        .add_needed('libui_shim.so'),

    'vendor/etc/init/thermal-mediatek.rc': blob_fixup()
        .regex_replace('android.hardware.thermal-service.mediatek', 'android.hardware.thermal-service.mediatek.scout'),

    'vendor/etc/init/hw/init.vendor.st21nfc.rc': blob_fixup()
        .regex_replace('libnfc-nci-st-felica.conf', 'libnfc-hal-st-felica.conf'),

    'vendor/bin/hw/android.hardware.biometrics.fingerprint-service.goodix': blob_fixup()
        .replace_needed('android.hardware.biometrics.fingerprint-V3-ndk.so', 'android.hardware.biometrics.fingerprint-V3-ndk-moto.so')
        .replace_needed('android.hardware.biometrics.common-V3-ndk.so', 'android.hardware.biometrics.common-V3-ndk-moto.so'),

    'vendor/lib64/android.hardware.biometrics.fingerprint-V3-ndk-moto.so': blob_fixup()
        .replace_needed('android.hardware.biometrics.common-V3-ndk.so', 'android.hardware.biometrics.common-V3-ndk-moto.so'),
    'vendor/lib64/android.hardware.biometrics.common.util-moto.so': blob_fixup()
        .replace_needed('android.hardware.biometrics.common-V3-ndk.so', 'android.hardware.biometrics.common-V3-ndk-moto.so'),

    # hardware/motorola/interfaces builds com.motorola.hardware.biometric.fingerprint
    # from source, which Soong puts in system, so the stock vendor copy has to be
    # renamed the same way the -V3-ndk pair above is. libgf_hal.so is the only
    # remaining consumer of the stock library and gets its DT_NEEDED rewritten.
    'vendor/lib64/libgf_hal.so': blob_fixup()
        .replace_needed('com.motorola.hardware.biometric.fingerprint-V2-ndk.so', 'com.motorola.hardware.biometric.fingerprint-V2-ndk-moto.so'),

    'vendor/bin/hw/motorola.hardware.sensorext-service': blob_fixup()
        .add_needed('libui_shim.so'),

    'vendor/lib64/libtpa.so': blob_fixup()
        .replace_needed('android.hardware.security.keymint-V3-ndk.so', 'android.hardware.security.keymint-V4-ndk.so'),

    ('vendor/bin/hw/vendor.mediatek.hardware.mtkpower-service.mediatek',
     'vendor/lib64/android.hardware.power-service-mediatek.so'): blob_fixup()
        .replace_needed('android.hardware.power-service-mediatek.so', 'android.hardware.power-service-mediatek.scout.so'),

}  # fmt: skip

module = ExtractUtilsModule(
    'scout',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()

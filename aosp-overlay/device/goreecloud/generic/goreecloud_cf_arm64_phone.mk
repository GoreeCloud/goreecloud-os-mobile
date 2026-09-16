# GoreeCloud file version: 0.1.0-dev1
# Development-only GoreeCloud product overlay for the AOSP Cuttlefish ARM64 phone.
# This target is not a physical-device definition and does not represent dre support.

$(call inherit-product, device/google/cuttlefish/vsoc_arm64/phone/aosp_cf.mk)

PRODUCT_NAME := goreecloud_cf_arm64_phone
PRODUCT_BRAND := GoreeCloud
PRODUCT_MODEL := GoreeCloud OS Mobile Cuttlefish ARM64
PRODUCT_MANUFACTURER := GoreeCloud

PRODUCT_SYSTEM_PROPERTIES += \
    ro.goreecloud.os.mobile.foundation=0.1.0-dev1 \
    ro.goreecloud.os.mobile.lifecycle=development \
    ro.goreecloud.os.mobile.platform_target=android17

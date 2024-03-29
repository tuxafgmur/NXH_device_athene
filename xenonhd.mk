# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit some common stuff.
$(call inherit-product, vendor/xenonhd/config/common_full_phone.mk)

$(call inherit-product, device/motorola/athene/full_athene.mk)

# Maintainer for this variant
PRODUCT_PROPERTY_OVERRIDES += ro.xenonhd.maintainer="Tuxafgmur"

# Boot animation
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 1920
TARGET_BOOTANIMATION_HALF_RES := true

ROOT_METHOD := su

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := athene
PRODUCT_NAME := xenonhd_athene
PRODUCT_BRAND := Motorola
PRODUCT_MANUFACTURER := Motorola
PRODUCT_RELEASE_NAME := athene

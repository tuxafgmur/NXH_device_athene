#!/bin/bash
# Copyright (C) 2016 - 2017 Tuxafgmur - Dhollmen 
# Modifies boot before build the image
# Parameters: 
#   1 = $(TARGET_DEVICE_DIR)
#   2 = $(TARGET_ROOT_OUT)

LOCALROOT=$2

rm -rf  $LOCALROOT/bugreports
rm -rf  $LOCALROOT/config
rm -rf  $LOCALROOT/d

mkdir -p $LOCALROOT/dsp
mkdir -p $LOCALROOT/firmware
mkdir -p $LOCALROOT/persist
mkdir -p $LOCALROOT/fsg

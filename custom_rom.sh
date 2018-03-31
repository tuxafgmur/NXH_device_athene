#!/bin/bash
# Copyright (C) 2016 - 2017 Tuxafgmur - Dhollmen 
# Removes unwanted files from the rom, before packaged it
# Parameters:
#   1 = $(TARGET_OUT)

WSYSTEMDIR=$1

rm -f  $WSYSTEMDIR/xbin/ps
rm -f  $WSYSTEMDIR/etc/recovery-resource.dat
rm -f  $WSYSTEMDIR/etc/Changelog.txt
rm -f  $WSYSTEMDIR/etc/init/debuggerd.rc
rm -f  $WSYSTEMDIR/etc/init/init-debug.rc
rm -fr $WSYSTEMDIR/etc/terminfo
rm -fr $WSYSTEMDIR/app/webview

FirstSortLine=`grep -n 'Additional Build Properties' $WSYSTEMDIR/build.prop | cut -d: -f1`
LastSortLine=`wc -l $WSYSTEMDIR/build.prop | cut -d ' ' -f1`
head -n $FirstSortLine $WSYSTEMDIR/build.prop > $WSYSTEMDIR/build.new
head -n $((LastSortLine)) $WSYSTEMDIR/build.prop | tail -n +$((FirstSortLine + 1)) | tr '\n[' '[\n' | sort | tr '\n[' '[\n' | grep -v '^\[$' | sort >> $WSYSTEMDIR/build.new
rm $WSYSTEMDIR/build.prop && mv $WSYSTEMDIR/build.new $WSYSTEMDIR/build.prop

sed '/dalvik.vm.stack-trace-file/d'                                         -i $WSYSTEMDIR/build.prop
sed '/ro.expect.recovery_id/d'                                              -i $WSYSTEMDIR/build.prop

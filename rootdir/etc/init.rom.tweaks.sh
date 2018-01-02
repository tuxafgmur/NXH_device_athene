#!/system/bin/sh
# Copyright 2017 Tuxafgmur - Dhollmen

export PATH=/sbin:/system/bin:/system/xbin

[ -f /system/etc/tweaks.conf ] && . /system/etc/tweaks.conf >/dev/null 2>&1

case $MAX_FREQ_BG in
    499200|800000|960000|1094400|1344000|1440000|1516800|1651200)
        setprop ro.boot.maxfreq $MAX_FREQ_BG
    ;;
esac

case $MIN_CPUS_ON in
    [0-4])
        setprop ro.boot.mincpus $MIN_CPUS_ON
    ;;
esac

case $BLK0_AHEAD in
    128|256|512|768|1024|1536|2048|3072)
        setprop ro.boot.ahead_blk0 $BLK0_AHEAD
    ;;
esac

case $BLK1_AHEAD in
    128|256|512|768|1024|1536|2048|3072)
        setprop ro.boot.ahead_blk1 $BLK1_AHEAD
    ;;
esac

case $BLK0_SCHED in
    cfq|deadline|fiops|noop|row|zen)
        setprop ro.boot.sched_blk0 $BLK0_SCHED
    ;;
esac

case $BLK0_SCHED in
    cfq|deadline|fiops|noop|row|zen)
        setprop ro.boot.sched_blk1 $BLK1_SCHED
    ;;
esac

case $MOUNT_ZRAM in
    Y|y)
        setprop ro.boot.zram 1
    ;;
esac

case $MOUNT_OEM in
    Y|y)
        setprop ro.boot.oemmnt 1
    ;;
esac

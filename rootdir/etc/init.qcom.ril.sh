#!/system/bin/sh

export PATH=/sbin:/system/bin:/system/xbin

multisim=`getprop persist.radio.multisim.config`

if [ "$multisim" = "dsds" ] || [ "$multisim" = "dsda" ]; then
    start ril-daemon1
fi

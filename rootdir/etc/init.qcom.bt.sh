#!/system/bin/sh
# Copyright (c) 2009-2013, The Linux Foundation. All rights reserved.

LOG_TAG="qcom-bluetooth"
LOG_NAME="${0}:"

loge () {
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi () {
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

failed () {
  loge "$1: exit code $2"
  exit $2
}

program_bdaddr () {
  /system/bin/btnvtool -O
  #logi "Bluetooth Address programmed successfully"
}


# enable bluetooth profiles dynamically

config_bt () {
  baseband=`getprop ro.baseband`
  target=`getprop ro.board.platform`
  if [ -f /sys/devices/soc0/soc_id ]; then
    soc_hwid=`cat /sys/devices/soc0/soc_id`
  else
    soc_hwid=`cat /sys/devices/system/soc/soc0/id`
  fi
  btsoc=`getprop qcom.bluetooth.soc`

  case $baseband in
    "apq")
        setprop ro.qualcomm.bluetooth.opp true
        setprop ro.qualcomm.bluetooth.ftp true
        setprop ro.qualcomm.bluetooth.nap false
        setprop ro.bluetooth.sap false
        setprop ro.bluetooth.dun false
        case $soc_hwid in
          "130")
              setprop ro.qualcomm.bluetooth.hsp true
              setprop ro.qualcomm.bluetooth.hfp true
              setprop ro.qualcomm.bluetooth.pbap false
              setprop ro.qualcomm.bluetooth.map false
              ;;
          *)
              setprop ro.qualcomm.bluetooth.hsp false
              setprop ro.qualcomm.bluetooth.hfp false
              setprop ro.qualcomm.bluetooth.pbap true
              setprop ro.qualcomm.bluetooth.map true
              ;;
        esac
        ;;
    "mdm" | "svlte2a" | "svlte1" | "csfb")
        setprop ro.qualcomm.bluetooth.opp true
        setprop ro.qualcomm.bluetooth.hfp true
        setprop ro.qualcomm.bluetooth.hsp true
        setprop ro.qualcomm.bluetooth.pbap true
        setprop ro.qualcomm.bluetooth.ftp true
        setprop ro.qualcomm.bluetooth.map true
        setprop ro.qualcomm.bluetooth.nap true
        setprop ro.bluetooth.sap true
        case $target in
          "apq8084")
              setprop ro.bluetooth.dun true
              logi "Enabling BT-DUN for APQ8084"
              ;;
          *)
              setprop ro.bluetooth.dun false
              ;;
        esac
        ;;
    "msm")
        setprop ro.qualcomm.bluetooth.opp true
        setprop ro.qualcomm.bluetooth.hfp true
        setprop ro.qualcomm.bluetooth.hsp true
        setprop ro.qualcomm.bluetooth.pbap true
        setprop ro.qualcomm.bluetooth.ftp true
        setprop ro.qualcomm.bluetooth.nap true
        setprop ro.bluetooth.sap true
        setprop ro.bluetooth.dun true
        case $btsoc in
          "ath3k")
              setprop ro.qualcomm.bluetooth.map false
              ;;
          *)
              setprop ro.qualcomm.bluetooth.map true
              ;;
        esac
        ;;
    *)
        setprop ro.qualcomm.bluetooth.opp true
        setprop ro.qualcomm.bluetooth.hfp true
        setprop ro.qualcomm.bluetooth.hsp true
        setprop ro.qualcomm.bluetooth.pbap true
        setprop ro.qualcomm.bluetooth.ftp true
        setprop ro.qualcomm.bluetooth.map true
        setprop ro.qualcomm.bluetooth.nap true
        setprop ro.bluetooth.sap true
        setprop ro.bluetooth.dun true
        ;;
  esac

  case $target in
    "msm8960")
       if [ "$btsoc" != "ath3k" ] && [ "$soc_hwid" != "130" ]; then
           setprop ro.bluetooth.hfp.ver 1.6
           setprop ro.qualcomm.bt.hci_transport smd
       fi
       ;;
    "msm8974" | "msm8226" | "msm8610" | "msm8916" | "msm8909" | "msm8952" )
       if [ "$btsoc" != "ath3k" ];  then
           setprop ro.bluetooth.hfp.ver 1.7
           setprop ro.qualcomm.bt.hci_transport smd
       fi
       ;;
    "apq8084" | "mpq8092" | "msm8994" )
       if [ "$btsoc" != "rome" ]; then
           setprop ro.qualcomm.bt.hci_transport smd
       elif [ "$btsoc" = "rome" ]; then
           setprop ro.bluetooth.hfp.ver 1.6
       fi
       ;;
    *)
       ;;
  esac

if [ -f /system/etc/bluetooth/stack.conf ]; then
    stack=`cat /system/etc/bluetooth/stack.conf`
fi

case "$stack" in
    "bluez")
	   #logi "Bluetooth stack is $stack"
	   setprop ro.qc.bluetooth.stack $stack
	   reason=`getprop vold.decrypt`
	   case "$reason" in
	       "trigger_restart_framework")
	           start dbus
	           ;;
	   esac
        ;;
    *)
	   # logi "Bluetooth stack is Bluedroid"
        ;;
esac

}

POWER_CLASS=`getprop qcom.bt.dev_power_class`
LE_POWER_CLASS=`getprop qcom.bt.le_dev_pwr_class`

setprop bluetooth.status off

case $POWER_CLASS in
  1) PWR_CLASS="-p 0" ;
     logi "Power Class: 1";;
  2) PWR_CLASS="-p 1" ;
     logi "Power Class: 2";;
  3) PWR_CLASS="-p 2" ;
     logi "Power Class: CUSTOM";;
  *) PWR_CLASS="";
     logi "Power Class: Ignored. Default(1) used (1-CLASS1/2-CLASS2/3-CUSTOM)";
     logi "Power Class: To override, Before turning BT ON; setprop qcom.bt.dev_power_class <1 or 2 or 3>";;
esac

case $LE_POWER_CLASS in
  1) LE_PWR_CLASS="-P 0" ;
     logi "LE Power Class: 1";;
  2) LE_PWR_CLASS="-P 1" ;
     logi "LE Power Class: 2";;
  3) LE_PWR_CLASS="-P 2" ;
     logi "LE Power Class: CUSTOM";;
  *) LE_PWR_CLASS="-P 1";
     logi "LE Power Class: Ignored. Default(2) used (1-CLASS1/2-CLASS2/3-CUSTOM)";
     logi "LE Power Class: To override, Before turning BT ON; setprop qcom.bt.le_dev_pwr_class <1 or 2 or 3>";;
esac

eval $(/system/bin/hci_qcomm_init -e $PWR_CLASS $LE_PWR_CLASS && echo "exit_code_hci_qcomm_init=0" || echo "exit_code_hci_qcomm_init=1")

case $exit_code_hci_qcomm_init in
  0) logi "Bluetooth QSoC firmware download succeeded, $BTS_DEVICE $BTS_TYPE $BTS_BAUD $BTS_ADDRESS";;
  *) failed "Bluetooth QSoC firmware download failed" $exit_code_hci_qcomm_init;

     setprop bluetooth.status off

     exit $exit_code_hci_qcomm_init;;
esac

setprop bluetooth.status on

exit 0

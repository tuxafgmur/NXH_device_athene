#!/system/bin/sh

set -A cinfo `cat /proc/cpuinfo | /system/bin/grep Revision`
hw=${cinfo[2]#?}

m2=${hw%?}
minor2=${hw#$m2}
m1=${m2%?}
minor1=${m2#$m1}
if [ "$minor2" == "0" ]; then
	minor2=""
	[ "$minor1" == "0" ] && minor1=""
fi
setprop ro.hw.revision p${hw%??}$minor1$minor2
unset hw cinfo m1 m2 minor1 minor2

echo 1 > /proc/config/reload

iccid=$(cat /proc/config/iccid/ascii 2>/dev/null)
[ ! -z "$iccid" ] && setprop ro.mot.iccid $iccid

unset iccid
cust_md5=$(cat /proc/config/cust_md5/ascii 2>/dev/null)
[ ! -z "$cust_md5" ] && setprop ro.mot.cust_md5 $cust_md5
unset cust_md5

pds_fti=/persist/factory/fti
set -A fti_pds $(hd $pds_fti 2>/dev/null)
[ $? -eq 0 ] && set -A fti $(hd $pds_fti 2>/dev/null)

utag_fti=/proc/config/fti
set -A fti_utag $(hd ${utag_fti}/ascii 2>/dev/null)
if [ $? -eq 0 ]; then
	if [ ! -z "${fti[153]}" ]; then
		if [ "${fti[75]}" != "${fti_utag[75]}" -o "${fti[94]}" != "${fti_utag[94]}" ]; then
			cat $pds_fti > ${utag_fti}/raw
		fi
	else
		set -A fti $(hd ${utag_fti}/ascii 2>/dev/null)
	fi
fi

mdate="Unknown"
y=0x${fti[73]}
m=0x${fti[77]}
d=0x${fti[78]}
let year=$y month=$m day=$d
if [ $month -le 12 -a $day -le 31 -a $year -ge 12 ]; then
	mdate=$month/$day/20$year
fi

setprop ro.manufacturedate $mdate
unset fti y m d year month day utag_fti pds_fti fti_utag mdate

t=$(getprop ro.build.tags)
if [[ "$t" != *release* ]]; then
	for p in $(cat /proc/cmdline); do
		if [ ${p%%:*} = "@" ]; then
			v=${p#@:}; a=${v%=*}; b=${v#*=}
			${a%%:*} ${a##*:} $b
	fi
	done
fi
unset p v a b t

product=$(getprop ro.hw.device)
model=$(cat /proc/config/model/ascii 2>/dev/null)
if [ $? -eq 0 ]; then
	if [ "${model#*_}" == "$product" -o "${model%_*}" == "$product" ]; then
		echo "" > /proc/config/model/raw
	fi
fi
unset model product

if [ "`getprop ro.build.type`" != "user" ]; then
	if [ -f /data/minFreeOff.txt ]; then
		if [ -e /proc/sys/vm/min_free_normal_offset ];	then
			echo -e `cat /data/minFreeOff.txt` > /proc/sys/vm/min_free_normal_offset
		fi
	fi
fi

[ -e /dev/vfsspi ] && setprop ro.mot.hw.fingerprint 1

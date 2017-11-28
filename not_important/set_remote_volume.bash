#!/bin/bash
#
# quick hack script
# Author: Steinar/LA7XQ
#

# Only initial values:
IP=""
CONTRL=Master
VOLUME=85
DEBUG=0
usage_exit() {
   echo "Usage:$(basename $0)"
   echo "Ex1: $(basename $0)"
   echo "Ex2: $(basename $0) 100 # set volume to 100%"
   exit 1
}

setvolumblackboxRPI() {
   #DEVICES=$(amixer scontrols | grep "Simple mixer control" | awk -F "Simple mixer control" '{print $2}' | tr -d "'" | awk -F "," '{print $1}' | awk '{print $1}' | sort | uniq)
   DEVICES=$(amixer controls | awk -F "'" '{print $2}' | grep Playback | awk '{print $1}' | sort | uniq)
   DEVICE=""
   FOUND=0
   for i in $DEVICES;do
      if [ "$i" = "Master" ];then
         DEVICE="$i"
         FOUND=1
         break
      fi
   done
   if [ $FOUND -eq 0 ];then
      for i in $DEVICES;do
         if [ "$i" = "PCM" ];then
            DEVICE="$i"
            FOUND=1
            break
         fi
      done
   fi
   [ $DEBUG -eq 0 ] || echo "DEVICE=$DEVICE"
   if [ ! -z "$DEVICE" ];then
      if [ $DEBUG -eq 0 ];then
         amixer -c 0 sset $DEVICE ${1}% >/dev/null 2>&1
         amixer get $DEVICE ${1}% >/dev/null 2>&1
      else
         amixer -c 0 sset $DEVICE ${1}%
         amixer get $DEVICE ${1}%
      fi
   fi
}

manualquestions() {
   YOUR_LAN_ADDR=$(hostname -I)
   echo "Your IP address: $YOUR_LAN_ADDR"
   echo
   echo -ne "Give remote IP addr: "
   read IP
   if [ "$IP"="$YOUR_LAN_ADDR" ];then
      echo "Oups: better start program with a volume argument given"
      echo "      as in example 2 below"
      usage_exit
   fi
   ssh pi@${IP} "amixer scontents;echo $?"

   echo -ne "Give control: [Master/PCM (try both)]: "
   read CONTRL

   echo -ne "Give volume [0-100]: "
   read VOLUME
}

if [ $# -eq 0 ];then
   manualquestions
   ssh pi@${IP} "amixer sset ${CONTRL} ${VOLUME}%;echo $?"
else
   IP=$(hostname -I)
   #ssh pi@${IP} "amixer sset ${CONTRL} ${VOLUME}%;echo $?"
   # amixer sset ${CONTRL} ${VOLUME}%
   if [ $1 -le 100 -a $1 -ge 0 ];then
      # amixer sset ${CONTRL} ${1}%
      setvolumblackboxRPI ${1}  # better find the correct device
   else
      echo "Illegal input for volume settings"
      usage_exit
   fi
fi
exit 0

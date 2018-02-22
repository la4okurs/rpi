#!/bin/bash
#
# quick hack script
#
# Author: Steinar/LA7XQ
#
# Program sets local or remote volume on RPI
#
# Only initial values:
IP=""
CONTRL=Master
VOLUME=85
DEBUG=0

usage_exit() {
   echo "Usage:$(basename $0)"
   echo "Ex1: $(basename $0)                      # get local volume"
   echo "Ex2: $(basename $0) user@192.168.0.201   # get remote volume set"
   exit 1
}

getvolumblackboxRPI() {
   # if Master is found, use it
   # test for PCM next...
   # SCONTROLS=$(amixer controls | awk -F "'" '{print $2}' | awk '{print $1}' | sort | uniq)
   SCONTROLS=$(amixer scontrols | grep "Simple mixer control" | awk -F "Simple mixer control" '{print $2}' | tr -d "'" | awk -F "," '{print $1}' | awk '{print $1}' | sort | uniq)
   SCONTROL=""
   FOUND=0
   for i in $SCONTROLS;do
      if [ "$i" = "Master" ];then
         SCONTROL="$i"
         FOUND=1
         break
      fi
   done
   if [ $FOUND -eq 0 ];then
      for i in $SCONTROLS;do
         if [ "$i" = "PCM" ];then
            SCONTROL="$i"
            FOUND=1
            break
         fi
      done
   fi
   [ $DEBUG -eq 0 ] || echo "SCONTROL=$SCONTROL"
   if [ ! -z "$SCONTROL" ];then
      if [ $DEBUG -eq 0 ];then
         amixer get $SCONTROL | grep -oE "^.*\[.*\]"
      else
         amixer get $SCONTROL | grep -oE "^.*\[.*\]"
      fi
   fi
}

if [ $# -ne 0 ];then
   if echo "$1" | grep -q -oE "\-h";then
      # as --help
      usage_exit
   fi
   ssh ${1} "[ -f $HOME/rpi/myradio/get_volume.bash ] && bash $HOME/rpi/myradio/get_volume.bash"
else
   IP=$(hostname -I)
   getvolumblackboxRPI
fi
exit 0

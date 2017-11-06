#!/bin/bash
# 
# This script is made for running on a RPI producing sound output sink to HDMI (HDMI screens)
# Note: If sound output is wanted on the RPI audio jack instead please change '-o hdmi' to '-o local'
#       below
#
# This script will keep listening for Norwegian ham VHF repeaters
# or any live stream from the server http://myradio.no
#
# As this server forward a proxy in my hut which retransmits also Apple HLS stream
# this script will listen for that stream at http://51.174.165.11:8888
# NOTE: this IP may be changed later on...
#
# Please perform an argument --help to see the program usage
#
# This script will kill all scripts equal this script name 
# but will leave this script running
# When only this script name is running it will then perform killing
# all $PROGs running, and will finally restart only one of the $PROGs
#
# Script made by Steinar/LA7XQ
#
# You may start this program in foreground or background
#
# ex0: 'bash listenvhf.bash start &'     # start in background 
# ex1: 'bash listenvhf.bash start'       # start in foreground
# ex2: 'bash listenvhf.bash stop'
# ex3: 'bash listenvhf.bash status'
# ex4: 'bash listenvhf.bash' # same as 'bash listenvhf.bash start'
# ex5: 'bash listenvhf.bash --help' # get program usage

PROG="/usr/bin/omxplayer" # Program which is wanted to restart if it stops

#PROGARGUMENTS="http://51.174.165.11:8888/hls/stream.m3u8 -o local"
PROGARGUMENTS="http://51.174.165.11:8888/hls/stream.m3u8 -o hdmi"
THISSCRIPT=$(basename $0)
OWNPIDS=$(pgrep -f $THISSCRIPT)
THISPROCESS=$$

usage_exit() {
   echo "Usage: $THISSCRIPT <start|stop|status|--help>"
   exit 0
}


# kill all scripts having the same script name as this one, but
# leave this (the last started) script run
killscriptofthistype() {
   for i in $OWNPIDS;do
      if [ ! "$i" = "$THISPROCESS" ];then
         kill -9 $i
      fi
   done
}

killandstart() {
   while true;do
      kill -9 $(pgrep -f $PROG) > /dev/null 2>&1
      sleep 2
      PROGG="$PROG $PROGARGUMENTS"
      $PROGG >/dev/null 2>&1 &
      sleep 1
      if pgrep -f $PROG >/dev/null 2>&1; then
         echo "==>$THISSCRIPT:$(date +%H:%M:%S):Restarted $PROGG"
         wait
      fi
      # if $PROG is killed or stopped this while loops will continue....
   done
}

start() {
   killscriptofthistype
   # At this point only one version (the last one) of this bash script is running
   killandstart
}

if [ ! -x $PROG ];then
   echo "Can't find access to $PROG"
   echo "This program is ONLY executing on an Raspberry Pi PC"
   echo "Now exit"
   exit 1
fi

case $1 in
   start)
      start
      ;;
   stop)
      echo "AHA, you want to stop everything (including yourself)"
      echo "I'll do..."
      killscriptofthistype
      kill -9 $(pgrep -f $PROG) > /dev/null 2>&1
      sleep 2
      kill -9 $$ # at last kill myself too !
      exit 1
      ;;
   --help|-h|--h)
      usage_exit
      ;;
   status)
      ps -ef | grep -i -E "$THISSCRIPT|$PROG" | grep -v grep
      exit 0
      ;;
   
   *) start
      ;;
esac


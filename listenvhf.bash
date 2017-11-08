#!/bin/bash
# 
# RPI VHF HAM RADIO RECEIVER
#
# Do you want your Raspberry PI to act as a ham VHF receiver
# without any HW add-on card needed or any extra piggyback card needed ?
#
# This is then the program that lets you listen at Norwegian VHF repeaters, both in scan mode and fixed frequency mode
#
# This script is made for running on a RPI producing sound output sink to HDMI (HDMI screens)
# Note: If sound output is wanted on the RPI audio jack instead please change SINK="local"
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

# sound output:
if [ "$2" = "jack" -o "$2" = "local" ];then
   SINK="local"  # sound output sinks to RPI analog jack connector (for headphones)
else
   # default
   SINK="hdmi"   # sound output sinks to hdmi audio sound in hdmi screens
fi


THISSCRIPT=$(basename $0)
OWNPIDS=$(pgrep -f $THISSCRIPT)
THISPROCESS=$$

usage_exit() {
   echo "Usage: $THISSCRIPT <start [jack]|stop|status|--help>"
   echo "examples:"
   echo "ex1: $THISSCRIPT          # start rendering HDMI audio (foreground)"
   echo "ex2: $THISSCRIPT start    # start rendering HDMI audio (foreground)"
   echo "ex3: $THISSCRIPT start &  # start rendering HDMI audio (background)"
   echo "ex4: $THISSCRIPT stop     # stop rendering audio"
   echo "ex5: $THISSCRIPT status   # get audio process status"
   echo "ex6: $THISSCRIPT jack     # start rendering audio to RPI jack audio connector (foreground)"
   echo "ex7: $THISSCRIPT jack &   # start rendering audio to RPI jack audio connector (background)"
   echo "ex8: $THISSCRIPT start jack   # start rendering audio to RPI jack audio connector (foreground)"
   echo "ex9: $THISSCRIPT start jack & # start rendering audio to RPI jack audio connector (background)"
   echo "ex10:$THISSCRIPT --help   # print this help usage"
   echo"";echo "INFO: rendering audio will default use HDMI if not 'jack' or 'local' specified"
   exit 0
}


# kill all scripts having the same script name as this one, but
# leave this (the last started) script run
killscriptofthistype() {
   for i in $OWNPIDS;do
      if [ ! "$i" = "$THISPROCESS" ];then
         kill -9 $i > /dev/null 2>&1
      fi
   done
}

killandstart() {
   while true;do
      kill -9 $(pgrep -f $PROG) > /dev/null 2>&1
      sleep 2
      #PROGARGUMENTS="--vol 500 http://51.174.165.11:8888/hls/stream.m3u8 -o $SINK"
      PROGARGUMENTS="http://51.174.165.11:8888/hls/stream.m3u8 -o $SINK"
      PROGG="$PROG $PROGARGUMENTS"
      $PROGG >/dev/null 2>&1 &
      sleep 1   
      if pgrep -f $PROG >/dev/null 2>&1 ; then
         echo -ne "==>$(date +%H:%M:%S): $PROG restarts: "
         # ps -ef | grep "$PROG " | grep -v grep
         echo "Now listening ham VHF stream. Adjust your audio volume..."
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
   echo "Can't find $PROG or no access"
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
      sleep 1
      ps -ef | grep "$PROG " | grep -v grep
      sleep 1
      kill -9 $$ > /dev/null 2>&1 # at last kill myself too !
      exit 1       # possibly not executed
      ;;
   --help|-h|--h)
      usage_exit
      ;;
   status)
      if pgrep -f $PROG >/dev/null 2>&1 ; then
         echo "$PROG is running:"
         ps -ef | grep "$PROG " | grep -v grep
      else
         echo "$PROG is not running"
      fi
      exit 0
      ;;
   jack)
      SINK="local"
      start
      ;;
   *) start
      ;;
esac

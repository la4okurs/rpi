#!/bin/bash
#  
# Do you want your Raspberry PI to act as a HAM VHF RADIO RECEIVER OR INTERNET STREAM RECEIVER
# WITHOUT any extra HAT (add-on card) needed ?
# (Just a pure Raspberry PI board needed)
#
# This is then the program that lets you listen at Norwegian VHF repeaters, both in scan mode and
# fixed frequency mode.
# You may also use this program to receive streams from other internet radio streaming stations
#
# This script is using vlc in a none GUI environment for better performance
# (cvlc)
# This program is intended for Linux PC, but not primarily for Raspberry PI

# Notice: On RPI use the program 'listenvhf.bash' instead of this one as this one is using
#         cvlc instead of the better omxplayer for RPI
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
# You may start this program in foreground or background, see examples in the 
# usage_exit() function below
#


THISSCRIPT=$(basename $0)

PSPROG="/usr/bin/vlc"
PROG="/usr/bin/cvlc" # Program which is wanted to restart if it stops
[ -f $PROG ] || { 
   echo "ERROR:$PROG not found."
   echo "Try first:"
   echo "sudo apt-get update"
   echo "(sudo apt-get purge vlc)"
   echo "sudo apt-get install vlc"
   echo "Now exit until above is done"
   exit 1
}


#PROGARGUMENTS="http://51.174.165.11:8888/hls/stream.m3u8"
PROGARGUMENTS="http://51.174.165.11:8888/hls/stream.m3u8"

OWNPIDS=$(pgrep -f $THISSCRIPT)
THISPROCESS=$$

old_usage_exit() {
   echo "Usage: $THISSCRIPT <start|stop|status|--help>"
   exit 0
}

usage_exit() {
   # echo "Usage: $THISSCRIPT <start [jack]|stop|status|--help>"
   echo
   echo " === HAM VHF RADIO RECEIVER AND INTERNET STREAM RECEIVER ==="
   echo
   echo "ERROR: You forgot to specify either you want to "start", "stop", "status" etc...."
   echo "       Just add this word as the last word in the command line"
   echo
   # sleep 2
   echo "       Press ENTER to see examples..."
   read
   echo "Usage: $THISSCRIPT [ http://...] <start |stop|status|--help>"
   echo "examples: As this is a bash script you may type in your Raspberry PI PC:"
   echo "ex1: bash $THISSCRIPT start    # start rendering HDMI audio (foreground)"
   echo "ex2: bash $THISSCRIPT start &  # start rendering HDMI audio (background)"
   echo "ex3: bash $THISSCRIPT stop     # stop rendering audio"
   echo "ex4: bash $THISSCRIPT status   # get audio process status"
   # echo "ex5: bash $THISSCRIPT jack     # start rendering audio to RPI jack audio connector (foreground)"
   # echo "ex6: bash $THISSCRIPT jack &   # start rendering audio to RPI jack audio connector (background)"
   # echo "ex7: bash $THISSCRIPT start jack   # start rendering audio to RPI jack audio connector (foreground)"
   # echo "ex8: bash $THISSCRIPT start jack & # start rendering audio to RPI jack audio connector (background)"
   echo "ex5: bash $THISSCRIPT --help   # print this usage help list"
   echo "ex6: bash $THISSCRIPT          # print this usage help list"
   # echo"";echo "INFO: rendering audio will default use HDMI if not 'jack' or 'local' specified"
   echo "other URLs examples (Notice: must start with http:// ):"
   echo "     bash $THISSCRIPT http://nrk-mms-live.telenorcdn.net:80/nrk_radio_p13_aac_h start # NRK P13"
   echo "     bash $THISSCRIPT http://stream.p4.no/p4_mp3_hq  start                            # P4"
   echo "     bash $THISSCRIPT http://streaming.radio.co/s9fa0dff72/listen  start              # Johnny Cash radio"
   echo "     as always:  bash $THISSCRIPT stop  # will stop rendering any audio"
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
      kill -9 $(pgrep -f $PSPROG) > /dev/null 2>&1
      sleep 1
      if [ -z "$1" ];then
         # do not change PROGARGUMENTS as current station is myradio.no server
         :
      else  
         PROGARGUMENTS="$1"
      fi
      PROGG="$PROG $PROGARGUMENTS"
      #echo "killandstart:\$PROG=$PROG, \$PROGARGUMENTS=$PROGARGUMENTS"
      
      #$PROGG >/dev/null 2>&1 &
      $PROGG 2>&1 | grep -i "input error" &  # vlc specific pot. errors
      sleep 1
      if pgrep -f $PSPROG>/dev/null 2>&1; then
         # $PROG is running
         # echo -ne "==>$(date +%H:%M:%S): $PSPROG restarts: "
         echo "==>$(date +%H:%M:%S): $PSPROG restarts: "
         # ps -ef | grep "$PSPROG " | grep -v grep
         if [ -z "$1" ];then
            echo "Now listening radio VHF stream at myradio.no Adjust your audio volume."
            echo "Notice: Silence now before radio squelch opens is normal. Stay tuned..."
         else
            echo "Now adjust your audio volume to proper value"
         fi
         wait
      fi
      # if $PROG is killed or stopped this while loops will continue....
   done
}

start() {
   killscriptofthistype
   # At this point only one version (the last one) of this bash script is running
   killandstart $1
}

if [ ! -x $PROG ];then
   echo "Can't find $PROG or no access"
   echo "Now exit"
   exit 1
fi

if echo "$1" | grep -q '^http://' ; then
   DIFFURL="$1"
   # echo "before shift: \@1=$1"
   # echo "before shift: \@2=$2"
   shift
   # echo "after shift: \@1=$1"
   # echo "after shift: \@2=$2"
else
   echo
   echo " === HAM VHF RADIO RECEIVER AND INTERNET STREAM RECEIVER ==="
   DIFFURL=""
fi
# echo "DIFFURL=$DIFFURL"

case $1 in
   start)
      start $DIFFURL
      ;;
   stop)
      echo "AHA, you want to stop everything (including yourself)"
      echo "I'll do..."
      killscriptofthistype
      kill -9 $(pgrep -f $PSPROG) > /dev/null 2>&1
      sleep 1
      ps -ef | grep "$PSPROG " | grep -v grep
      sleep 1
      kill -9 $$ > /dev/null 2>&1 # at last kill myself too !
      exit 1
      ;;
   --help|-h|--h)
      usage_exit
      ;;
   status)
      if pgrep -f $PSPROG >/dev/null 2>&1 ; then
         # ret value 0
         echo "$PSPROG is running:"
         ps -ef | grep "$PSPROG " | grep -v grep
      else
         echo "$PSPROG is not running"
      fi
      exit 0
      ;;
   
   *) usage_exit
      ;;
esac


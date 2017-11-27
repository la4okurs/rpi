#!/bin/bash
#
# Script Status: 90% done
#
# Author: Steinar/LA7XQ
#

DEBUG=0 # 0 or 1
GETIPPROG="$HOME/rpi/getip"
STREAMPROG="$HOME/rpi/not_important/stream.bash"

##@reboot /bin/bash /home/pi/rpi/not_important/wake_streamprog.bash start >/dev/null 2>&1 &
##@reboot /bin/bash /home/pi/rpi/not_important/wake_streamprog.bash nrk >/dev/null 2>&1 &
#@reboot /bin/bash /home/pi/rpi/not_important/wake_streamprog.bash ham >/dev/null 2>&1 &

THISSCRIPT=$(basename $0)
OWNPIDS=$(pgrep -f $THISSCRIPT)
THISPROCESS=$$

# own user:
# @reboot /bin/bash $HOME/rpi/not_important/wake_streamprog.bash p4 >/dev/null 2>&1 


echoo() {
   # get rid of many echoes
   [ $DEBUG -ne 0 ] && echo "$@"
}

usage_exit() {
   echo "Usage: $(basename $0) <stream.bash radio channel>"
   echo "       example: $(basename $0) p4"
   echo
   echo "See also the usage for the $HOME/rpi/not_important/stream.bash"
   exit 1
}

killscriptofthistype() {
   for i in $OWNPIDS;do
      if [ ! "$i" = "$THISPROCESS" ];then
         kill -9 $i > /dev/null 2>&1
      fi
   done
}

start_stream() {
   bash $STREAMPROG $1
}

if [ $# -ne 1 ];then
   echoo "ERROR, wrong usage"
   usage_exit
fi

main() {
   for i in {1..20};do
      if [ -f $GETIPPROG ];then
         echoo "i=$i"
         if [ $DEBUG -eq 0 ];then
            bash $GETIPPROG -w  >/dev/null 2>&1
            RET=$?
         else
            bash $GETIPPROG -w 
            RET=$?
         fi
         echoo "==>RET=$RET"
         if [ $RET -ne 0 ];then
            echoo "$(basename $0): Mobile network not up yet. Sleep 5 sec and try again"
            sleep 5 
            continue
         fi
         start_stream $1
         return 0
      else
         echoo "$(basename $0): file $GETIPPROG is missing. Now return 1"
         return 1
      fi
   done
}

[ $# -eq 0 ] && usage_exit 
[ -f $STREAMPROG ] || {
   echoo;echoo "$(basename $0): ERROR: $STREAMPROG not found."
   echoo "Try first installing $STREAMPROG first. Now exit"
   exit 1
}

# The program will call subprograms that needs cvlc
[ -f /usr/bin/cvlc ] || {
   echoo;echoo "$(basename $0): ERROR: /usr/bin/cvlc not found."
   echoo "Try first installing vlv and cvlc by doing:"
   echoo "sudo apt-get update"
   echoo "(sudo apt-get purge vlc)"
   echoo "sudo apt-get autoremove vlc"
   echoo "sudo apt-get install vlc"
   echoo "Now exit until above is done"
   exit 1
}

killscriptofthistype

while true;do
   main $1
   MAINRET=$?
   # echoo "MAINRET=$MAINRET"
   if [ $MAINRET -ne 0 ];then
      echoo "main: Try again"
      continue
   else
      while true; do
         # test if net still up...
         if [ $DEBUG -eq 0 ];then
            bash $GETIPPROG -w  >/dev/null 2>&1
            RRET=$?
         else
            bash $GETIPPROG -w 
            RRET=$?
         fi
         # echoo "==>RRET=$RRET"
         if [ $RRET -eq 0 ];then
            sleep 5 # all OK net is up
            continue
         else
            break
         fi
         break
      done
   fi
done

# should not end up here
exit 0

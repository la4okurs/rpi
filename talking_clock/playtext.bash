#!/bin/bash
#
# A text2speech script
#
# Made by: Steinar/LA7XQ
#
# Script status: Seems OK
#
# This script use the 'pico2wave' program
#
# Install:
# $ apt-cache search --full pico2wave
# Package: libttspico-utils
# Install by:
# sudo apt-get install libttspico-utils
# /usr/bin/pico2wave --help
#
# ------------ cron job proposal: --------- start--------------
#@reboot /usr/bin/amixer cset numid=3 1 >/dev/null 2>&1 # 3 1=analog jack, 3 2=HDMI, 3 0=auto (priority on HDMI if present)
##@reboot /bin/bash $HOME/rpi/myradio/set_volume.bash 45 >/dev/null 2>&1 # %
#@reboot /bin/bash $HOME/rpi/myradio/set_volume.bash 80 >/dev/null 2>&1 # %
#@reboot /bin/sleep 10;/bin/bash $HOME/rpi/myradio/bradio.bash >/dev/null 2>&1 &  # press button to get first stream
# ---------- text2speech ------------------
#28 * * * * /bin/bash $HOME/rpi/talking_clock/playtext.bash "I love you my talking guy." >/dev/null 2>&1
# ------------ cron job proposal: --------- end--------------

help_exit() {
   echo "Usage: $(basename $0) \"type your text here\""
   echo "or"
   echo "Usage: $(basename $0) textfile"
   exit 1
}

if [ $# -ne 1 -o "$1" = "--help" ];then
   help_exit
fi

WAVFILE="$(dirname $0)/talkinsound.wav"
[ -f $WAVFILE ] && rm -f $WAVFILE

TEXT="$1"
if [ -f "$1" ];then
   TEXT=$(cat $1)
else
   TEXT=${TEXT:-"Look at the usage example above"}
fi

#/bin/bash $HOME/rpi/myradio/set_volume.bash 95 >/dev/null 2>&1 # see cronjob

/usr/bin/pico2wave -w "${WAVFILE}" "${TEXT}"
[ -f /usr/bin/mplayer ] || { echo "/usr/bin/mplayer not found. Install by 'sudo apt-get install mplayer2' first. Now exit"; exit 1; }
#/usr/bin/aplay --disable-softvol "${WAVFILE}"
/usr/bin/mplayer "${WAVFILE}" >/dev/null 2>&1

exit $?

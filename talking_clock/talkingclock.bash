#!/bin/bash
#
# The talking clock
#
# Made by: Steinar Wenaas
#
# Script status: Seems good
# This script use the 'pico2wave' program
#
# pi@rpi3-voice:~/rpi/svar $ apt-cache search --full pico2wave
# Package: libttspico-utils
# Install by:
# sudo apt-get install libttspico-utils
# /usr/bin/pico2wave --help
#
# where to output sound:

# ------------ cron job proposal: --------- start--------------
# ---------- On reboot, prepare botton radio, start with silence,operate button to get sound -----:
#@reboot /usr/bin/amixer cset numid=3 1 >/dev/null 2>&1 # 3 1=analog jack, 3 2=HDMI, 3 0=auto (priority on HDMI if present)
##@reboot /bin/bash $HOME/rpi/myradio/set_volume.bash 45 >/dev/null 2>&1 # %
#@reboot /bin/bash $HOME/rpi/myradio/set_volume.bash 80 >/dev/null 2>&1 # %
#@reboot /bin/sleep 10;/bin/bash $HOME/rpi/myradio/bradio.bash >/dev/null 2>&1 &  # press button to get first stream

# ---------- talking clock ----------
#00 * * * * /bin/bash $HOME/rpi/talking_clock/talkingclock.bash >/dev/null 2>&1
##17 * * * * /bin/bash $HOME/rpi/talking_clock/talkingclock.bash "I love you honey" >/dev/null 2>&1
# ------------ cron job proposal: --------- start--------------

help_exit() {
   echo "Usage: $(basename $0) \"type your text here\""
   sleep 1
}
if [ $# -ne 1 ];then
   help_exit
fi
WAVFILE="$(dirname $0)/talkinsound.wav"
[ -f $WAVFILE ] && rm -f $WAVFILE
TEXT=""
TEXT=${TEXT:-"Time is ! $(date '+%H %M') ! "}
#/bin/bash $HOME/rpi/myradio/set_volume.bash 65 >/dev/null 2>&1 # 
MORETEXT="$1"
TOTTEXT="${TEXT} ${MORETEXT}"
/usr/bin/pico2wave -w "${WAVFILE}" "$TOTTEXT" >/dev/null 2>&1
[ -f /usr/bin/mplayer ] || { echo "/usr/bin/mplayer not found. Install by 'sudo apt-get install mplayer2' first. Now exit"; exit 1; }
/usr/bin/mplayer "${WAVFILE}" >/dev/null 2>&1
exit $?

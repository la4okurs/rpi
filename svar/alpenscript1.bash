#!/bin/bash
#
# A simple script version to play alpen music
# Stop rendering audio with typing Cntrl C (^C)
#
# Author: Steinar/LA7XQ
# INFO:
# '>/dev/null 2>&1' below means: ignore any printout(s) from the statement in front
#
# NOTICE: be sure first to install alsa-utils (amixer) and vlc packages or vlc-nox (vlc and cvlc)
#         first before running this script if amixer and vlc is not yet installed on your RPI:
# sudo apt-get update
# sudo apt-get install alsa-utils
# sudo apt-get install vlc
#
# (You may use other players as well)
#

echo "Good morning Arnfinn !"
/usr/bin/amixer cset numid=3 1   >/dev/null 2>&1  # force RPI audio output to the 3.5 mm jack, ignore printout
# /usr/bin/amixer cset numid=3 2  # use this instead if audio output force to HDMI screen is wanted (requre HDMI speakers)
kill -9 $(pgrep -f /usr/bin/vlc) >/dev/null 2>&1 # kill all (c)vlc processes already started, ignore print out
cvlc https://radio04.alpenmelodie.de:8443/alpenmelodie >/dev/null 2>&1 # play the alpen music, ignore prinout
exit $? # transfer the cvlc exit value to the outer shell

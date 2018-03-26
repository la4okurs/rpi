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
echo "Do you hear the alpen melodie in your jack connector headphones?"
echo "Adjust volume..."
VLC=$(which "vlc" | grep -E "bin.*vlc$")

/usr/bin/amixer cset numid=3 1    >/dev/null 2>&1  # force audio output to jack, ignore printout
# /usr/bin/amixer cset numid=3 2  # force audio output to HDMI screen (if HDMI speakers present)
kill -9 $(pgrep -f $VLC) >/dev/null 2>&1 # kill (c)vlc if already started,ignore print out
cvlc https://radio04.alpenmelodie.de:8443/alpenmelodie >/dev/null 2>&1 # ignore prinout
exit 0

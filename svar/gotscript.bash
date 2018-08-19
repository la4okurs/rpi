#!/bin/bash
#
# A simple script version to play music from the Gotradio
# on a Raspberry PI PC
#
# Stop rendering audio with typing Cntrl C (^C)
#
# Author: Steinar/LA7XQ
# INFO:
#
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
echo "Do you hear the Gotradio in your RPI audio jack connector (headphones)?"
echo "Adjust volume..."
CVLC=$(which "cvlc" | grep -E "bin.*vlc$")
KILL_VLC=$(which "vlc" | grep -E "bin.*vlc$")

/usr/bin/amixer cset numid=3 1    >/dev/null 2>&1  # force audio output to 1=jack, ignore printout
# /usr/bin/amixer cset numid=3 2  >/dev/null 2>&1  # uncomment this line if sinking to 2=HDMI screen instead (HDMI speakers needed)
kill -9 $(pgrep -f $KILL_VLC) >/dev/null 2>&1           # kill (c)vlc process if already started, ignore print out
$CVLC http://gotradio-edge1.cdnstream.com/1182_128?listenerid=da4dfc5beb929b932c861a5ac02e05f3&esPlayer&cb=290873.mp3 >/dev/null 2>&1 # ignore prinout
exit 0

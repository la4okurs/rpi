#!/bin/bash
#
# A simple script version to play alpen music
# Stop rendering audio with typing Ctrl C (^C)
#
# Author: Steinar/LA7XQ
#
# INFO:
# '>/dev/null 2>&1' below means: ignore any printout(s) from the statement in front
#
# NOTICE: be sure first to install alsa-utils (amixer) and vlc packages or vlc-nox (vlc and cvlc)
#         first before running this script if amixer and vlc is not yet installed on your RPI:
# sudo apt-get update
# sudo apt-get install alsa-utils
# sudo apt-get install vlc    # or   sudo apt-get install vlc-nox 
#
# (You may use other players as well)
#
echo "Good morning OM!"
echo "Now listening (scanning) the ham VHF repeaters in the South East of Norway"
echo "Please listen at your Raspberry PC audio jack connector (headphones) now"
echo "Silence ? OK , it is silence when nobody on the repeater(s)"
echo "Best regards Steinar/LA7XQ who made this program"
echo
echo "(Type Ctrl C to stop this program)"
/usr/bin/amixer cset numid=3 1   >/dev/null 2>&1  # force RPI audio output to the 3.5 mm jack, ignore printout
# /usr/bin/amixer cset numid=3 2  # use this instead if audio output force to HDMI screen is wanted (requre HDMI speakers)
kill -9 $(pgrep -f /usr/bin/vlc) >/dev/null 2>&1 # kill all (c)vlc processes already started, ignore print out
cvlc http://51.174.165.11:8888/hls/stream.m3u8 >/dev/null 2>&1 # listen ham FM VHF repeaters
exit $? # transfer the cvlc exit value to the outer shell

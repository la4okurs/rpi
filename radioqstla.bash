#!/bin/bash
#
# A simple hack script quickly made to listen to the Norwegian QSTLA transmission
#
# Stop rendering audio with typing Ctrl C (^C)
#
# Author: Made by Steinar/LA7XQ
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
echo "Usage: $(basename $0)"
echo "or"
echo "Usage: $basename $0) cvlc"
echo
ping -c 1 216.58.207.206 >/dev/null 2>&1
RET=$?
if [ $RET -ne 0 ];then
   echo "== You have no connection to Inet =="
   echo "Fix this first, then restart the program"
   exit 0
fi
[ -f /usr/bin/cvlc ] || {
   echo;echo "$(basename $0): ERROR: /usr/bin/cvlc not found."
   echo "Be sure to have installed the package vlc or vlc-nox first by doing:"
   echo "sudo apt-get update"
   echo "(sudo apt-get purge vlc)"
   echo "sudo apt-get autoremove vlc"
   echo "sudo apt-get install vlc"
   echo "Now exit until above is done"
   exit 1
}

[ -f /usr/bin/amixer ] || {
   echo;echo "$(basename $0): ERROR: /usr/bin/amixer not found."
   echo "Be sure to have installed the package alsa-utils first by doing:"
   echo "sudo apt-get update"
   echo "sudo apt-get install alsa-utils"
   echo "Now exit until above is done"
   exit 1
}


echo "Good morning OM!"
echo "Now listening (scanning) the ham VHF repeaters in the South East of Norway"
echo "Please listen at your Raspberry PC audio jack connector (headphones) now"
echo "Silence ? Forgotten to turn up the volume? OK, it is silence when nobody on the repeater(s)"
echo;echo "Best regards Steinar/LA7XQ who made this program"
echo;echo "(Type Ctrl C to stop this program)"
/usr/bin/amixer cset numid=3 1   >/dev/null 2>&1  # force RPI audio output to the 3.5 mm jack, ignore printout
# /usr/bin/amixer cset numid=3 2  # use this instead if audio output force to HDMI screen is wanted (requre HDMI speakers)
kill -9 $(pgrep -f /usr/bin/vlc) >/dev/null 2>&1 # kill all (c)vlc processes already started, ignore print out
if [ $# -ne 0 ];then
   cvlc $(cat ./myradio/radiolist | grep qst | awk '{print $3}' | grep qstlalast.mp3) >/dev/null 2>&1
else
   vlc $(cat ./myradio/radiolist | grep qst | awk '{print $3}' | grep qstlalast.mp3) >/dev/null 2>&1
fi
exit $? # transfer the cvlc exit value to the outer shell

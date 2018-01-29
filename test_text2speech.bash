#!/bin/bash
#
# The program tests the pico2wave text2speech program
# 
# Author: Steinar/LA7XQ
#         hack bash script skrevet av Steinar i full fart
#
# Remember to select audio output to RPI audio jack or HDMI and possibly adjust volume of your headphones
#

TEXT2SPEECHPROG="/usr/bin/pico2wave"

# check access first:
if [ ! -f /usr/bin/aplay ];then
   echo "ERROR: The  /usr/bin/aplay program seems not to be installed on your RPI"
   echo "Hint: install it by doing 'sudo apt-get install alsa-utils' first"
   exit 1
fi
if [ ! -f /usr/bin/aplay ];then
   echo "ERROR: The  /usr/bin/aplay program seems not to be installed on your RPI"
   echo "Hint: install it by doing 'sudo apt-get install alsa-utils' first"
   exit 1
fi
if [ ! -f /usr/bin/amixer ];then
   echo "ERROR The /usr/bin/amixer program is not yet installed"
   echo "Hint: install it by doing 'sudo apt-get install libttspico-utils' first"
   exit 1
fi
quest_bin() {
   RET=0
   while true;do
      echo
      echo -ne "$1 [$2/$3]?: "
      read ans
      ans=$(echo $ans | cut -c 1)
      case "$ans" in
         $2) RET=1;break;;
         $3) RET=2;break;;
         *)  continue;;
      esac
   done
   return $RET
}

echo "INFO: Type Ctrl C when you want to quit"
SOUNDFILE="./mysound.wav"
rm -f $SOUNDFILE
quest_bin "Do you want audio output to jack(j) or HDMI(h)" "j" "h"
RET=$?
if [ $RET -eq 1 ];then
   /usr/bin/amixer cset numid=3 1 >/dev/null 2>&1
elif [ $RET -eq 2 ];then
   /usr/bin/amixer cset numid=3 2 >/dev/null 2>&1
else
   :
fi

INTROTEXT="Good morning! I am the text to speech program script made by lima alfa 7 ex ray quebec! Steinar. Now you can try. Have fun !"
echo "$INTROTEXT"
/usr/bin/pico2wave -w $SOUNDFILE "$INTROTEXT"
aplay $SOUNDFILE
echo;echo "NOTICE: You may need to select the audio jack connector (for headphones) or HDMI sound speakers on RPI first"
echo "        Remember to adjust volume as well"
rm -f $SOUNDFILE
while true
do
   echo
   echo -ne "Input some new text (or Ctrl C): ";read ANS
   /usr/bin/pico2wave -w $SOUNDFILE "$ANS"        # create the sound file
   aplay $SOUNDFILE                               # play the sound file
   rm -f $SOUNDFILE                               # clean up after playing
done


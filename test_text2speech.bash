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
if [ ! -f $TEXT2SPEECHPROG ];then
   echo "ERROR The text2speech program called '$TEXT2SPEECHPROG' is not yet installed"
   echo "Hint: install it by doing 'sudo apt-get install libttspico-utils' first"
   exit 1
fi

echo "INFO: Type Ctrl C when you want to quit"
SOUNDFILE="./mysound.wav"
rm -f $SOUNDFILE

INTROTEXT="Good morning! I am the text to speech program script made by lima alfa 7 ex ray quebec! Steinar. Now you can try. Have fun !"
echo "$INTROTEXT"
/usr/bin/pico2wave -w $SOUNDFILE "$INTROTEXT"
aplay $SOUNDFILE
echo;echo "NOTICE: You may need to select the audio jack connector (for headphnoes) or HDMI sound speakers on RPI first"
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

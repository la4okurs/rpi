#!/bin/bash
#
# The program tests the pico2wave text2speech program
# 
# Author: Steinar/LA7XQ
#         hack bach script skrevet av Steinar i full fart
#
# Remember to possibly adjust your headphone volume
#

TEXT2SPEECHPROG="/usr/bin/pico2wave"
if [ ! -f $TEXT2SPEECHPROG ];then
   echo "ERROR The text2speech program called '$TEXT2SPEECHPROG' is not yet installed"
   echo "Hint: install it by doing 'sudo apt-get install libttspico-utils' first"
   exit 1
fi
echo "INFO: Type Ctrl C when you want to quit"
SOUNDFILE="./mysound.wav"
rm -f $SOUNDFILE

INTROTEXT="Good morning! I am the text to speech program. Now you can try"
echo "$INTROTEXT"
/usr/bin/pico2wave -w $SOUNDFILE "$INTROTEXT"
aplay $SOUNDFILE
rm -f $SOUNDFILE

while true
do
   echo
   echo -ne "Input some new text (or Ctrl C): ";read ANS
   echo "Now play back...listen, you may need to adjust volume"
   echo "for your headphones (or select HDMI output)"
   /usr/bin/pico2wave -w $SOUNDFILE "$ANS"        # create the sound file
   aplay $SOUNDFILE                               # play the sound file
   rm -f $SOUNDFILE                               # clean up after playing
done


#!/bin/bash
#
# The program tests the pico2wave text2speech program
# 
# Author: Steinar/LA7XQ
#         hack bach script skrevet av Steinar i full fart
#
# Remember to possibly adjust your headphone volume
#

TEXT2SPEECHPROG="/usr/bin/pico2wave"
if [ ! -f $TEXT2SPEECHPROG ];then
   echo "ERROR The text2speech program called '$TEXT2SPEECHPROG' is not yet installed"
   echo "Hint: install it by doing 'sudo apt-get install libttspico-utils' first"
   exit 1
fi
echo "INFO: Type Ctrl C when you want to quit"
SOUNDFILE="./mysound.wav"
rm -f $SOUNDFILE

INTROTEXT="Good morning! I am the text to speech program script made by lima alfa 7 ex ray quebec! Steinar. Now you can try"\
"Have fun"
echo "$INTROTEXT"
/usr/bin/pico2wave -w $SOUNDFILE "$INTROTEXT"
aplay $SOUNDFILE
rm -f $SOUNDFILE

while true
do
   echo
   echo -ne "Input some new text (or Ctrl C): ";read ANS
   echo "Now play back...listen, you may need to adjust volume"
   echo "for your headphones (or select HDMI output)"
   /usr/bin/pico2wave -w $SOUNDFILE "$ANS"        # create the sound file
   aplay $SOUNDFILE                               # play the sound file
   rm -f $SOUNDFILE                               # clean up after playing
done


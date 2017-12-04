#!/bin/sh
#
# Author: Steinar/LA7XQ
#

killscriptofthistype() {
   for i in $(pgrep -f $(basename $0));do
      if [ ! "$i" = "$$" ];then
         kill -9 $i > /dev/null 2>&1
      fi
   done
}

kill_earlier() {
   kill -9 $(pgrep -f $1) >/dev/null 2>&1
}

killscriptofthistype
kill_earlier gpio_in_callbacks_start_stream.py

python $HOME/rpi/not_important/gpio_in_callbacks_start_stream.py > /dev/null 2>&1 &
echo
echo "Press the GPIO23 (phys pin 16) GPIO.IN mounted button for a new stream. Last stream selected will silence the radio"
echo "The LED lits permanent when staying on the ham radio stream"
echo

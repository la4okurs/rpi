#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program will do....text to come here...
#
# Author: Steinar/LA7XQ
#
# Doc:
# https://sourceforge.net/p/raspberry-gpio-python/wiki/Inputs/
#
#@reboot /bin/bash $HOME/rpi/not_important/set_volume.bash 75 # %
#@reboot /usr/bin/python $HOME/rpi/not_important/gpio_in_callbacks_start_stream.py >/dev/null 2>&1 &


# IMPORT AREA
import sys 
import RPi.GPIO as GPIO              # import RPi.GPIO module
import subprocess
import time
import ledblueforstreams
# GLOBAL DATA AREA
GPIO.setmode(GPIO.BCM)               # BCM for GPIO numbering
gpioport = 23 # phys pin 16
GPIO.setup(gpioport, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)     # or PUD_UP


sleeptime = 20
count=-1
ledblueforstreams.turnledoff()

# FUNCTION AREA
def my_callback(gpioport):
    global count
    count = count + 1
    if count > 4:
       count = 0
    if count == 3:
       ledblueforstreams.turnledon()
    else:
       # print "Set volume 75%"
       # out = subprocess.check_output("/bin/bash $HOME/rpi/not_important/set_volume.bash 75 >/dev/null 2>&1",shell=True)
       ledblueforstreams.turnledoff()

    print "===>my_callback: This is a edge event callback function!"
    print "Edge detected on gpioport %s" % (gpioport)
    print "This is run in a different thread to your main program"
    print  time.ctime()
    print "count=%s" % (count)
    # /bin/bash $HOME/rpi/not_important/wake_streamprog.bash nrk >/dev/null 2>&1 &
    if count == 0:
       print "nrk P1"
       out = subprocess.check_output("/bin/bash /home/pi/rpi/not_important/wake_streamprog.bash nrk >/dev/null 2>&1 &",shell=True)
    elif count == 1:
       print "Johnny Cash"
       out = subprocess.check_output("/bin/bash /home/pi/rpi/not_important/wake_streamprog.bash johnny >/dev/null 2>&1 &",shell=True)
    elif count == 2:
       print "P4"
       out = subprocess.check_output("/bin/bash /home/pi/rpi/not_important/wake_streamprog.bash p4 >/dev/null 2>&1 &",shell=True)
    elif count == 3:
       print "HAM"
       out = subprocess.check_output("/bin/bash /home/pi/rpi/not_important/wake_streamprog.bash ham >/dev/null 2>&1 &",shell=True)
    elif count == 4:
       print "SILENCE"
       out = subprocess.check_output("/bin/bash /home/pi/rpi/not_important/wake_streamprog.bash stop >/dev/null 2>&1 &",shell=True)
    else:
	pass
    print "count=%s" % count


# MAIN AREA
if __name__ == "__main__":
   # GPIO.add_event_detect(gpioport, GPIO.RISING, callback=my_callbacs)  # add rising edge detect
   # add rising edge detection on a channel
   # ignoring further edges for 200ms for switch bounce handling
   GPIO.remove_event_detect(gpioport) # optional, remove old ones...
   GPIO.add_event_detect(gpioport, GPIO.RISING, callback=my_callback, bouncetime=200) # in ms
 
   # GPIO.add_event_callback(gpioport, my_callback_one) # if more functions, introduce them
   ledblueforstreams.turnledon()
   time.sleep(1)
   ledblueforstreams.turnledoff()
   
   print "I will now sleep for %s seconds" % (sleeptime)
   print "If key pressed I will leave this main program"
   while True:
      time.sleep(30)


   sys.exit(0) # All exits back to outer shell should leave 0 if no error(s) and >< 0 if failing

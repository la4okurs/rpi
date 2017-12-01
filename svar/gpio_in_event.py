#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program will do..
#
# Author: Steinar/LA7XQ
#
# Doc:
# https://sourceforge.net/p/raspberry-gpio-python/wiki/Inputs/
#


# IMPORT AREA
import sys 
import RPi.GPIO as GPIO              # import RPi.GPIO module
import subprocess
import time

# GLOBAL DATA AREA
GPIO.setmode(GPIO.BCM)               # BCM for GPIO numbering
gpioport = 23 # phys pin 16
GPIO.setup(gpioport, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)     # or PUD_UP

# FUNCTION AREA
def do_something():
   sleeptime = 5
   print ""
   print "I am sleeping now for %s seconds..." % (sleeptime)
   time.sleep(sleeptime)


# MAIN AREA
if __name__ == "__main__":
   # INFO: do add_event_detect  only one time !
   GPIO.add_event_detect(gpioport, GPIO.RISING)   # add rising edge detection on a gpioport
   while True:
      do_something() # do finish this WITHOUT any interruption....even if button is pressed

      # now test afterwards if something (an event) had happen while I was doing the do_something job...:
      if GPIO.event_detected(gpioport):
         print "Status: ===> Button was pressed while I was sleeping"
      else:
         print "Status: No Button action  while I was sleeping"


   sys.exit(0) # All exits back to outer shell should leave 0 if no error(s) and >< 0 if failing

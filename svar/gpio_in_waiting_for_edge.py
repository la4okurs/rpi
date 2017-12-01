#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program shows an small example running code (a job) without interruption, 
# but still possible to ask afterwards if
# something happened (to the button) after the job was done
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


# MAIN AREA
if __name__ == "__main__":

   print "now stay in next statement (wait_for_edge statement) (but wait max 10 seconds)
   print "Leave next statement at once if button is pressed within that time"
   out = GPIO.wait_for_edge(gpioport, GPIO.RISING, timeout=10000) # wait max 10 sec
   if out is None:
      print "Timeout occurred"
   else:
      print "Edge detected on gpioport %s" % (gpioport)


   sys.exit(0)

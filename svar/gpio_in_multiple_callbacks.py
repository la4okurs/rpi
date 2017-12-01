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

sleeptime = 20

# FUNCTION AREA
def my_callback(gpioport):
    print "===>my_callback: This is a edge event callback function!"
    print "Edge detected on gpioport %s" % (gpioport)
    print "This is run in a different thread to your main program"
    print  time.ctime()

def my_callback_one(gpioport):
    print "Callback one"
    print  time.ctime()


def my_callback_two(gpioport):
    print "Callback two"
    print  time.ctime()


# MAIN AREA
if __name__ == "__main__":
   # add event detect , introduce the callback functions:
   GPIO.add_event_detect(gpioport, GPIO.RISING, callback=my_callback)  # add rising edge detect
   GPIO.add_event_callback(gpioport, my_callback_one) # if more functions, introduce them
   GPIO.add_event_callback(gpioport, my_callback_two) # if more functions, introduce them
   
   print "I will now sleep for %s seconds" % (sleeptime)
   print "If key pressed I will leave this main program"
   time.sleep(sleeptime)
   print "I am back in the main area. I have finished my sleep"


   sys.exit(0) # All exits back to outer shell should leave 0 if no error(s) and >< 0 if failing

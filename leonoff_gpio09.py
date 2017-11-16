#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
#
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program will turn on/off a LED on the bread bord or on a RPI HAT board
#
# Author: Steinar/LA7XQ
#


# IMPORT AREA
import sys 
import RPi.GPIO as GPIO
import time


# GLOBAL DATA AREA
GPIOPORT=9            # defines which GPIO port (Notice NOT the same as PHYSICAL pin no!) to work on,GPIO09 = phys pin 21
                      # Notice: This pin has to be wired up from the RPI to the bread bord first
                      # If you wire up other pin, this GPIO number must be 
                      # changed accordingly
                          
GPIO.setmode(GPIO.BCM)        # Set GPIO pinout scheme a la Broadcom Inc.
GPIO.setwarnings(False)       # optional, just to avoid a GPIO warning printed out on screen
GPIO.setup(GPIOPORT,GPIO.OUT) # prepare the GPIOPORT's usage, should the pin be an output or input pin
                              # here GPIOPORT port is to used as an OUTput device


# FUNCTION AREA
def turnledon():
   GPIO.output(GPIOPORT,GPIO.HIGH)

def turnledoff():
   GPIO.output(GPIOPORT,GPIO.LOW)




# MAIN AREA
if __name__ == "__main__":
   turnledon()
   time.sleep(2)
   turnledoff()
   time.sleep(2)

   
   sys.exit(0) # All exits back to outer shell should leave 0 if no error(s) and >< 0 if failing

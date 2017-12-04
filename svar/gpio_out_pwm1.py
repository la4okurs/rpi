#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program gives a short blink based on the GPIO Pulse Width Modulation scheme
# The example also use physical pin numbering scheme as BOARD pinning is used
#
# Author: Steinar/LA7XQ
#


# IMPORT AREA
import RPi.GPIO as GPIO
import sys 


# GLOBAL DATA AREA
GPIO.setmode(GPIO.BOARD)        # BOARD mens use physical pin scheme
gpioport=22                     # here phys pin 22  (GPIO25)
GPIO.setup(gpioport, GPIO.OUT)


# FUNCTION AREA



# MAIN AREA
if __name__ == "__main__":
   p = GPIO.PWM(gpioport, 0.5)  # prepare output pin for PWM with frequency 0.5 Hz 
   p.start(2)                   # start PWM with duty cycle 2 %, i.e will cause a short LED blink. (range 0-100)
   raw_input("Press return to stop blinking:") # use input(" ") statement if using Python3
   p.stop()                     # stop PWM

   # proper GPIO cleanup as well as return to outer shell with no expected errors:
   GPIO.cleanup()
   sys.exit(0) # All exits back to outer shell should leave 0 if no error(s) and >< 0 if failing

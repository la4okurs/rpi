#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
# 
# This program shows GPIO PWM usage,duty cycle change from 0% to 100%
# used to dim up/dim down a LED (Nice for Christmas !)
#
# This example use physical pin numbering scheme as BOARD pinning is used
# This program is using GPIO Pulse Width Modulation scheme
# by manipulating with the PWM duty cycle , see p.ChangeDutyCycle(dc) below
#
# This example also shows a keyboard interrupt handling, ie code to
# fetch a keyboard interrupt and handle it, see the try/except handling
# This latter to ensure that we will run a proper finish of code
# as p.stop() and GPIO.cleanup() will be performed
#
# I regard this Python example to be a proper way of writing 
# 
# Author: Steinar/LA7XQ
#


# IMPORT AREA
import RPi.GPIO as GPIO
import time
import sys 


# GLOBAL DATA AREA
GPIO.setmode(GPIO.BOARD)        # BOARD means use PHYSICAL RPI pin scheme
gpioport=22                     # here phys pin 22  (GPIO25)
GPIO.setup(gpioport, GPIO.OUT)  # define the gpioport to be an GPIO OUTPUT PORT


# FUNCTION AREA

 


# MAIN AREA
if __name__ == "__main__":

   p = GPIO.PWM(gpioport, 50)  # define the gpioport to use Pulse Width Modulation with a frequency of 50Hz
   p.start(0)                  # start the PWM (actually force voltageto the pin)
   try:
      while True:
         # glow up the LED: 
         for dc in range(0, 101, 5):
            p.ChangeDutyCycle(dc)  # increase from 0% to 100% duty cycle, step of 5 % ("dim up part")
            time.sleep(0.1)        # free some CPU cycles in the loop
         
         # dim the LED:
         for dc in range(100, -1, -5):
            p.ChangeDutyCycle(dc)  # decrease the duty cycle from 100% to 0% ("dim down part")
            time.sleep(0.1)        # free some CPU cycles in the loop
   except KeyboardInterrupt:
      # execute this block if Ctrl C=KeyboardInterrupt is typed on the keyboard
      print "I am the exception code that avoid the code to bail out"

   # continue here after running the print statement above
   p.stop() # Stop the PWM scheme. PWM will also stop if the instance variable 'p' goes out of scope

   # proper GPIO cleanup as well as return to outer shell with no expected errors:
   GPIO.cleanup() # reset the GPIO setup
   sys.exit(0)    # All exits back to outer shell should leave 0 if no error(s) and >< 0 if failing

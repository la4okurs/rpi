#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA explaining what the program is doing, any copyrights, licenses, etc
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program will do shutdown when button is pressed (hold the key down for
# a while). Wait until all RPI LEDs freeze, THEN pull the main power
#
# Author: Steinar/LA7XQ
#


# IMPORT AREA
import sys 
import RPi.GPIO as GPIO              # import RPi.GPIO module
import subprocess
import time

# GLOBAL DATA AREA
GPIO.setmode(GPIO.BCM)               # BCM for GPIO numbering
#GPIO.setmode(GPIO.BOARD)             # BOARD for P1 pin numbering

gpioport = 23 # phys pin 16
GPIO.setup(gpioport, GPIO.IN)     # set port/pin as an input
GPIO.setup(gpioport, GPIO.IN,  pull_up_down=GPIO.PUD_DOWN) # input with pull-down
#GPIO.setup(gpioport, GPIO.IN,  pull_up_down=GPIO.PUD_UP)   #  input with pull-up


# MAIN AREA
if __name__ == "__main__":
   while True:
      # when button open ==> 1, when pressed ===> 0
      i = GPIO.input(gpioport)    # read status of pin/port and assign to variable i
      print i
      if i == 0:
         out = subprocess.check_output("sudo init 0",shell=True)  # better for testing
         print out
      time.sleep(0.2)
   
   sys.exit(0)

#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA
# Copyright 2017 MyLittleCompany
# Licensed under the ... License, Version X.X
#
# This program will do GPIO polling....
#
# Author: Steinar/LA7XQ
#

# IMPORT AREA
import sys 
import RPi.GPIO as GPIO      # import RPi.GPIO module alias to GPIO
import subprocess            # possible call shell cmds
import time

# GLOBAL DATA AREA
GPIO.setmode(GPIO.BCM)       # BCM = Broadcom Inc defined GPIO pinning scheme
#GPIO.setmode(GPIO.BOARD)     # BOARD for physical pin numbering

gpioport = 23 # phys pin 16
GPIO.setup(gpioport, GPIO.IN) # set port/pin as an input
GPIO.setup(gpioport, GPIO.IN,  pull_up_down=GPIO.PUD_DOWN) # input port
#GPIO.setup(gpioport, GPIO.IN, pull_up_down=GPIO.PUD_UP)   # input port



# MAIN AREA
if __name__ == "__main__":

   # endless polling....
   while True:
      # read button 1 or 0 as result:
      i = GPIO.input(gpioport) # read level og the gpioport pin
      print i
      time.sleep(0.2)          # sleep to offload the CPU
   
   sys.exit(0) # Exit 0 = success to outer bash shell

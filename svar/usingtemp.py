#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# TEXT AREA
# Dette programmet (denne filen) skal du kalle usingtemp.py
# og dette programmet skal kalle begge funksjonene du laget i temperature.py programmet
# ved hjelp av import (module) i Python

# IMPORT AREA
import sys 
import temperature   # import functions defined in the temperature.py

# MAIN AREA
if __name__ == "__main__":

   temperature.calc_fahrenheit()
   temperature.calc_celsius()

   sys.exit(0)


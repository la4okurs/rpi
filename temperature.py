#!/bin/env/python
# -*- coding: utf-8 -*-
#
# TEXT AREA
# Programmet skal bestå av to funksjoner:
# Første funksjon skal 
# kalkulere fahrenheit grader fra oppgitt celsius område, kalt calc_fahrenheit()
# der celsiusområdet er fra -10 til +10 grader celsius (begge tall inklusive, se nedenfor)
#
# Andre funksjon skal 
# kalkulere celsius grader fra oppgitt fahrenheit område, kalt calc_celsius()
# der fahrenheit området er fra 14 til 50 grader fahrenheit (begge tall innklusive)
#
#
# Programmet feiler slik det nå er skrevet (Prøv å start det!)
# men oppgaven består i å fullføre programmet
# ved at du skal lage den funksjonen som mangler og så kalle begge funksjoner fra MAIN AREA
#
# Kall programmet temperatur.py
# (Sjekk at tabell verdiene fra begge funksjoner syntes å stemme)
#
# PS: ikke bry deg om rette marger denne gang eller antall desimaler i resultat tallene
#     Det viktige denne gang er å skjønne funksjoner og funksjonskall, hvordan de lages
#     og kalles  
#
# Oppgitt: algoritmer:
# Fra celsius til fahrenheit: f = 1.8 *c + 32
# Fra fahrenheit til celsius: c = (f - 32 ) * 0.56

# IMPORT AREA
import sys 


# GLOBAL DATA AREA
# a = 3 # substitute a or other data to be your own data
#

# FUNCTION AREA
# change the 'pass' statement below to be your own statements
def calc_fahrenheit():
   print ""
   print "calc_fahrenheit:"
   print "Celius Fahrenheit"
   for c in range(-10,11,1):
      f = 1.8 *c + 32
      print c,f



# MAIN AREA
if __name__ == "__main__":

   calc_fahrenheit()
   calc_celsiu... # dette funksjonskallet feiler, rett opp denne linjen

   sys.exit(0)



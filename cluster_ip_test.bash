#!/bin/bash#

# The program test a collection of machines on a LAN network
# to verify that they are all up running 
#
# The test is based in the -c option in the getip program
#
# Author: Steinar/LA7XQ
#         hack script skrevet av Steinar i full fart
#
IPLIST="192.168.0.1 192.168.0.3 192.168.0.12 192.168.0.13 192.168.0.230"
LOGFILE="%$(basename $0).log"
rm -f $LOGFILE
echo "$(date): Cluster ping test started. See $LOGFILE" >> $LOGFILE
while true; do
   bash getip -c "$IPLIST"
   [ $? -ne 0 ] && { bash getip -c "$IPLIST" >> $LOGFILE; break; }
   sleep 15
done
echo "$(date): FAILING: At least one node has failed, see log in $LOGFILE" | tee -a $LOGFILE
exit 1

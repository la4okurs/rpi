#!/bin/bash
LOGFILE="%$(basename $0).log"
rm -f $LOGFILE
echo "Cluster ping test started at $(date)" >> $LOGFILE
while true; do
   bash getip -c "192.168.0.1 192.168.0.3 192.168.0.12 192.168.0.13 192.168.0.230"
   [ $? -ne 0 ] && break
   sleep 15
done
echo "Cluster ping test stopped at $(date)" >>$LOGFILE
bash getip -c "192.168.0.1 192.168.0.3 192.168.0.12 192.168.0.13 192.168.0.230" >>$LOGFILE
exit 1

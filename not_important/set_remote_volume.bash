#!/bin/bash
#
# quick hack script 
# Author: Steinar/LA7XQ
#
echo -ne "Give remote IP addr: "
read IP
#echo "IP=$IP"

echo -ne "Give control: [Master/PCM (try both)]:"
read CONTRL
#echo "CONTRL=$CONTRL"
echo -ne "Give volume [0-100]:"
read VOLUME
#echo "VOLUME=$VOLUME"

ssh pi@${IP} "amixer sset ${CONTRL} ${VOLUME}%;echo $?"

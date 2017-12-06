#!/bin/bash
#
# make file for running static IPs
#
# Script status: working, not finished
#
# Author: Steinar/LA7XQ
#
#
 

BASE="192.168.0"
STATIC_ETHIP="${BASE}.241\/24"
STATIC_ROUTERS="${BASE}.1"

#FILETOCOPY="/etc/dhcpcd.conf"
FILETOCOPY="/etc/dhcpcd.conf.org"
FILEWORK="/etc/dhcpcd.conf.mine"
rm -f $FILEWORK

if [ -f $FILETOCOPY ];then
   cp $FILETOCOPY $FILEWORK
   RET=$?
   if [ $RET -ne 0 ];then
      echo "Can't cp $FILETOCOPY $FILEWORK"
      echo "Now exit"
      exit 1
   fi
else
   echo "No $FILETOCOPY found. No sense running this script. Now exit"
   exit 1
fi

linetochange() {
   if grep "$1" $FILEWORK >/dev/null 2>&1 ;then
      sed -i -e "s/^$1/$2/g" $FILEWORK
   fi
}
linetomodify() {
   if grep "$1" $FILEWORK >/dev/null 2>&1 ;then
      sed -i -e "s/^$1.*/$2/g" $FILEWORK
   fi
}
linetochange "#interface eth0" "interface eth0"

linetomodify "#static ip_address" "static ip_address=$STATIC_ETHIP"
linetomodify "#static routers" "static routers=${STATIC_ROUTERS}"
linetomodify "#static domain_name_servers" "static domain_name_servers=${STATIC_ROUTERS} 8.8.8.8 8.8.4.4"
linetomodify "#static domain_search" "static domain_search=8.8.8.8"

echo "interface wlan0" >> $FILEWORK
echo "static ip_address=$STATIC_ETHIP" | sed -e 's/\\//g' >> $FILEWORK
echo "static routers=${STATIC_ROUTERS}" >> $FILEWORK
echo "static domain_name_servers=${STATIC_ROUTERS} 8.8.8.8 8.8.4.4" >> $FILEWORK
echo "static domain_search=8.8.8.8" >> $FILEWORK
echo
echo "NOTICE!! This script is not yet finished, more code to come...."
exit 0

#!/bin/bash
#
# Run this script on the Rasbian Stretch distro
# Run this script on a (server) RPI on which you want to establish an static IP LAN server address
#
# Notice: This script should be executed as a 'sudo', but script gives a warning if not having root access
#
# Author: Steinar/LA7XQ
#
# SCRIPT STATUS: Seems OK
# 
FILETOAPPEND="/tmp/$(basename $0).app"
DHCPC_FILE="/etc/dhcpcd.conf"

quest_bin() {
   RET=0
   while true;do
      echo
      echo -ne "$1 $2 $3 $4: "
      read ans
      case "$ans" in
         192.168.0) RET=1;break;;
         192.168.1) RET=2;break;;
         10.0.0)    RET=3;break;;
         *)  continue;;
      esac
   done
   return $RET
}

askForIP() {
   # loop until correct format given (not a complete test)
   # call like 'askForIP "Give IPv4 address you want as static IP" "192.168.1.1"' # output is IP
   while true;do
      echo;echo -ne "$1 (give IP(s) or just ENTER to get suggested value): "
      read IP
      if [ -z "$IP" ];then
         IP="$2"
      fi
      echo "$IP" | grep -q -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
      RET=$?
      [ $RET -eq 0 ] && break
   done
   echo $IP
   return 0
}

getLAN() {
   echo -ne "IP LAN address is:"
   # ip addr | egrep -e "inet.*global" | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | awk '{print "    ", $2,$NF}'
   ip addr | egrep -e "inet.*global" | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >/dev/null 2>&1
   RET=$?
   [ $RET -ne 0 ] && { echo " NONE"; echo "Is your network turned OFF or have you specified incorrect SSID/key password ?"; }
   ip addr | egrep -e "inet.*global" | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | awk '{print "", $2,$NF," <==="}'
}

getGATEWAY() {
   if netstat -r | grep -v "^Destination" | grep -q -E " 0.0.0.0 .*G";then
      GATEWAYIP=$(netstat -rn | grep -v "^Destination" | grep -E " 0.0.0.0 .*G" | awk '{print $2}' | head -n 1)
      echo "$GATEWAYIP"
      return 0
   else
      echo ""
      return 1
   fi
}

restoreToNoneStatic() {
   sed -i '/^interface /d' $1
   sed -i '/^fallback static/d' $1
   sed -i '/^static ip_address=/d' $1
   sed -i '/^static routers=/d' $1
   sed -i '/^static domain_name_servers=/d' $1
   sed -i '/^static domain_search=/d' $1
   sed -i '/^noipv6/d' $1
}

cleanup() {
   [ -f $1 ] && rm -f $1
}

isRaspStrectch() {
   [ -f /etc/os-release ] || { return 1; }
   if ! cat /etc/os-release | grep -q "^ID=raspbian";then
      cat /etc/os-release | grep "ID="
      return 1
   else
      if ! cat /etc/os-release | grep -E "^VERSION=.*\(.*stretch";then
         echo "You have:"
         cat /etc/*rel* | grep -E "^VERSION="
         echo "(You may find some info inside '/etc/wpa_supplicant/wpa_supplicant.conf')"
         return 1
      else
         return 0
      fi
   fi
   return 1
}

echo
NO=$(id -u)
[ $NO -ne 0 ] && { echo "ERROR: Disable networks and restart this script as 'sudo bash $0'"; exit 1; }
[ -f $DHCPC_FILE ] || { echo "Is this not an Raspbian Stretch distro ? Now exit"; exit 1; }
# echo "Run this script on the Rasbian Stretch distro"
# echo "Run this script on the RPI you want the static LAN address"
isRaspStrectch
RETCHK=$?
# echo "RETCHK=$RETCHK"
if [ $RETCHK -ne 0 ];then
   echo "Sorry this function is only valid if you are running Raspian Stretch distro"
   exit 0
#else
#   chknetwork
fi
echo "This host $(hostname) is assumed being the ssh server side"

cleanup $FILETOAPPEND
touch $FILETOAPPEND

# Interfaces:
WIFI_INTERFACE=$(ifconfig -a | grep -i -E "^w" | awk '{print $1}')
ETH_INTERFACE=$(ifconfig -a | grep -i -E "^e" | awk '{print $1}')
ETH_INTERFACE=$(echo $ETH_INTERFACE | awk -F ":" '{print $1}' | awk '{print $1}')
WIFI_INTERFACE=$(echo $WIFI_INTERFACE | awk -F ":" '{print $1}' | awk '{print $1}')
echo;echo "Network interfaces found:"
echo $ETH_INTERFACE
echo $WIFI_INTERFACE

echo "interface $ETH_INTERFACE" >> $FILETOAPPEND
echo "fallback static_$ETH_INTERFACE" >> $FILETOAPPEND
PURELANIP=$(getLAN | awk -F ":" '{print $2}' | awk -F "/" '{print $1}' | awk '{print $1}')

DEFAULT="$PURELANIP"
askForIP "Give IPv4 address you want as static IP [I suggest like '$DEFAULT']" "$DEFAULT" # output is IP
STATIC_IP="$IP"
echo "static ip_address=${STATIC_IP}/24" >> $FILETOAPPEND

#DEFAULT=$(echo "$STATIC_IP" | awk -F "." '{printf $1"."$2"."$3".1"}')
GATEWAYIP=$(getGATEWAY)
RET=$?
if [ $RET -ne 0 ];then
   echo "Current Gateway: NONE <==="
   echo "Is your network turned OFF?"
   echo "Now exit"
   exit 1
fi
DEFAULT="$GATEWAYIP"
askForIP "Give IP address to gateway (router) [I suggest like '$DEFAULT']" "$DEFAULT" # output is IP
ROUTERS_IP="$IP"
echo "static routers=$ROUTERS_IP" >> $FILETOAPPEND

DEFAULT="8.8.8.8"
askForIP "Give domain name servers [I suggest like '$DEFAULT']" "$DEFAULT" # output is IP
DOM_NAME_SERVERS="$IP"
echo "static domain_name_servers=$ROUTERS_IP $DEFAULT fd51:42f8:caae:d92e::1" >> $FILETOAPPEND

DEFAULT="$ROUTERS_IP $DOM_NAME_SERVERS"
askForIP "Give static domain_search [I suggest these two: '$DEFAULT']" "$DEFAULT" # output is IP
DOM_NAME_SEARCH="$IP"
echo "static domain_search=$DOM_NAME_SEARCH" >> $FILETOAPPEND
echo "noipv6" >> $FILETOAPPEND

echo "interface $WIFI_INTERFACE" >> $FILETOAPPEND
echo "static ip_address=${STATIC_IP}/24" >> $FILETOAPPEND
echo "static routers=$ROUTERS_IP" >> $FILETOAPPEND
DEFAULT="8.8.8.8"
echo "static domain_name_servers=$ROUTERS_IP $DEFAULT fd51:42f8:caae:d92e::1" >> $FILETOAPPEND
echo "static domain_search=$DOM_NAME_SEARCH" >> $FILETOAPPEND
echo "noipv6" >> $FILETOAPPEND

[ -f $DHCPC_FILE ] || { echo "Can not find your $DHCPC_FILE file. Now exit"; exit 1; }
#cp $DHCPC_FILE ${DHCPC_FILE}_bac_$(date "+%H%M%S")

restoreToNoneStatic $DHCPC_FILE # after this $DHCPC_FILE should be as org for none static IPs
echo;echo "INFO: Typing Ctrl C now will restore DHCP (none static IPs) again - type ENTER if still STATIC is wanted. After this, reboot RPI";read

cat $DHCPC_FILE $FILETOAPPEND > ${DHCPC_FILE}.1
if cp ${DHCPC_FILE}.1 ${DHCPC_FILE};then
   echo "A new ${DHCPC_FILE} file is created."
   RET=0
else
   echo "ERROR when 'cp ${DHCPC_FILE}.1 ${DHCPC_FILE}'. Now exit"
   RET=1
fi 
cleanup $FILETOAPPEND
cleanup ${DHCPC_FILE}.1

echo;echo "====> Now reboot your RPI. IP $STATIC_IP should then be static instead of DHCP"
echo "Next: open port 22 for ssh        (using port forward in the router) on LAN addr $STATIC_IP"
echo "Next: open port 5900 for vncviewer (using port forward in the router) on LAN addr $STATIC_IP"
exit $RET




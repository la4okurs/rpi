#!/bin/bash
#
# This script will detect remote part possible to connect over an cable between two Linux PC (RPI)
# with a router needed
# Prerequisites:
#       Execute this script on the ssh client side
#       On the RPI server side it is assumed that "enable ssh server","enable VNC server" are
#       already set and an (static) IP address is set on eth (Ethernet) and that an eth cross
#       cable is attached between the two RPIs
# Wire up an eth cross cable between the two RPIs. No router is needed
#
# On the remote ssh server side, disable the WiFI network. Keep only the Eth network up
# and write down the IP address (eth) using 'hostname -I' or LA7XQ script doing 'rpi/svar/getip -l'
# Now disable both WiFi on the (ssh) server side

# On the local (ssh) client side, disable both WiFi and Eth and then start this script
# again
#
# Notice: This script should be executed as a 'sudo bash $0' in from of script: 'sudo thisscript'
#
# Author: Steinar/LA7XQ
#
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
echo
NO=$(id -u)
[ $NO -ne 0 ] && { echo "ERROR: Disable networks and restart this script as 'sudo bash $0'"; exit 1; }
echo "This host $(hostname) is assumed being the ssh client side"
echo "Be sure to have done "enable ssh", "enable vnc" on the RPI ssh server side using 'sudo raspi-config'"
echo "Be sure you have set a server side LAN IP addr on the eth interface"
echo "Be sure to have a eth cross cable connected between the 2 RPIs"
echo "Be sure having disabled the WiFi network (but not the Eth) on the remote (ssh) server side"
echo "Be sure having disabled both WiFI and Eth network on this client side"
echo "(This script will set up the eth network on this client side again....)"
echo
echo "I assume you have completed the above actions needed before you continue here"
echo "If so, type ENTER to continue running this script..";read

while true;do
   quest_bin "which IP base do you want on this client? (should be same as base as on the remote ssh server), either " "192.168.0" "192.168.1" "10.0.0"
   RET=$?
   # echo "RET=$RET"
   IP_ADDRB=""
   if [ $RET -eq 1 ];then
      IP_ADDRB="192.168.0"
      break
   elif [ $RET -eq 2 ];then
      IP_ADDRB="192.168.1"
      break
   elif [ $RET -eq 3 ];then
      IP_ADDRB="10.0.0"
      break
   else
      continue
   fi
done
NETW_INTERFACE=$(ifconfig -a | grep -E "Link encap.*Ethernet" | grep -i "^e" | awk '{print $1}')
ifconfig $NETW_INTERFACE ${IP_ADDRB}.219 up
RET_IF=$?
if [ $RET_IF -ne 0 ];then
   echo "Try restarting this script running as 'sudo bash $0'"
   exit 1
fi
#ifconfig -a
#hostname 
LANIP=$(hostname -I | awk '{print $1}')
# [ -f $HOME/rpi/getip ] && bash $HOME/rpi/getip -b
[ -f $HOME/rpi/getip ] && bash $HOME/rpi/getip -l
echo "wait while scanning for other(s) on this network...."
if [ -f $HOME/rpi/getip ];then
   SOMEFOUND=0
   # echo "Now scanning for others on this network...."
   IPRANGE=$(bash $HOME/rpi/getip -a | grep -i "scan report" | awk '{print $NF}')
   for i in $IPRANGE;do
      echo "$i" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
      IPRET=$?
      [ $IPRET -ne 0 ] && continue
      if [ "$i" = "$LANIP" ];then
         echo "yourself found       : $i"
      else
         SOMEFOUND=1
         echo "remote other(s) found: $i"
      fi
   done
   if [ $SOMEFOUND -eq 0 ];then
      echo "Sorry, can't find any remote IP"
      exit 1
   fi 
   echo;echo "Now try to ping, ssh and VNC others with the IP(s) found"
   exit 0
else
   echo "The program file $HOME/rpi/getip is not found. Now exit"
   exit 1
fi

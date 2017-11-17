#!/bin/bash
#requires 'sudo'
SHOWCACHE=1
SHOWCACHE=0
DOPING=1
DOPING=0
QUIET=0
QUIET=1

IPLIST=$(arp | awk '{print $1}' | grep -v Address)
IPLIST=$(echo "$IPLIST" | sort -h)

getLAN() {
   ip addr | egrep -e "inet.*global" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1
}

BASE=$(getLAN | awk -F"." '{printf $1"."$2"."$3}')


arp_delete_all() {
   if [ $QUIET -eq 0 ];then
      echo;echo "deleting all ARP cache entries in the subnet with base $BASE ....:"
   fi
   for i in {1..255};do
      sudo arp -d ${BASE}.$i >/dev/null 2>&1
      RET=$?
      if [ $RET -ne 0 ];then
         if [ $QUIET -eq 0 ];then
            echo "arp DO NOT delete OK on ${BASE}.$i"
            echo "arp was failing on arp -d ${BASE}.$i"
         fi
      else
         if [ $QUIET -eq 0 ];then
            echo "arp delete OK on ${BASE}.$i"
         fi
      fi
   done
}

arp_call_all() {
   if [ $QUIET -eq 0 ];then
      echo;echo "arping all entries in subnet regardless of any cached up:"
   fi
   for i in {1..255};do
      arp ${BASE}.$i >/dev/null 2>&1
      RET=$?
      if [ $RET -ne 0 ];then
         if [ $QUIET -eq 0 ];then
            echo "arp ${BASE}.$i  is NOT OK"
         fi
      else
         if [ $QUIET -eq 0 ];then
            echo "arp ${BASE}.$i  is OK"
         fi
      fi
      if [ $DOPING -ne 0 ];then 
         ping -c 2 $i >/dev/null 2>&1
         RET=$?
         if [ $RET -ne 0 ];then
            if [ $QUIET -eq 0 ];then
               echo "==>INFO(E): Arp found ${i}, but can't ping $i"
            fi
         else
            if [ $QUIET -eq 0 ];then
               echo "==>INFO:    Arp found and can ping $i"
            fi
         fi
      fi
   done
}

if [ $SHOWCACHE -ne 0 ];then
   echo "I am at $(hostname -I)"
   echo "Currently seen in ARP cache:"
   echo "$IPLIST"
fi

arp_delete_all
arp_call_all
echo;echo "After deleting all entries in ARP cache and arping all once more,"
echo " === Final arp table reestablished (seen from this node $(hostname -I)) ===:"
arp
exit $?


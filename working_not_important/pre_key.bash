#!/bin/bash
#
# Script status: work in progress, more to come....
#
# Author: Steinari/LA7XQ
#

GOWNER="steinar.wenaas@gmail.com"
isRPI() {
   # return 0 if its a RPI
   if cat /proc/cpuinfo | grep -q -i -E 'Hardware.*BCM2'; then
     if cat /proc/cpuinfo | grep -q -i -E "(^model name.*ARMv6-compatible processor|ARMv7.*processor)";then
        return 0
     fi
   fi
   return 1
}
isRPI
RET=$?
if [ $RET -ne 0 ];then
   echo "ERROR: This host ($(hostname)) is likely not an RPI"
   echo "You should run this script on an RPI only"
   echo "Now exit"
   exit 1
fi

while true;do
  echo -ne "Give email address: "
  read GANS
  # echo "GANS=$GANS"
  NOWORDS=$(echo "GANS=$GANS" | wc -w | awk '{print $1}')
  if ! echo $GANS | grep -q "@" ;then
     echo "Not a valid email address"
     continue
  fi
   
  if [ $NOWORDS -ne 1 ];then
     echo "Notice: Plase no space in the email address!"
     continue
  else
     break
  fi
done
# echo "So far: GANS=$GANS"
# cat /proc/cpuinfo | grep Serial
NO=$(cat /proc/cpuinfo | grep Serial | awk '{print $NF}')
echo;echo "Please send back an email to $GOWNER containing the next line:"
echo "Pre Key: $GANS $NO"
echo;echo "You will then receive an email back with the final key to use"
exit 0

#!/bin/bash
#
# Author: Steinar/LA7XQ
#
# This script transfers files through secure copy
#
# Notice!! Be sure to change your FROM_IP, USER and PORT before using this script
#
FROM_IP="192.168.0.237"
USER="rpi"
PORT=37

FROM_USER="${USER}@${FROM_IP}"
FROM_UPLOAD_DIR="/home/${USER}/rpi"
if [ "$FROM_IP" = "$(hostname -I | awk '{print $1}')" ]; then
   echo "This is your source host $(hostname -I)"
   echo "Do not try to destroy the source host"
   echo "Now exit"
   exit 1
fi
 
if [ -d $(pwd)/rpi ];then
   echo "You have already an existing $(pwd)/rpi directory"
   echo "I don't like to destroy any local files you have" 
   echo;echo "Please backup and the remove or move your local rpi directoryi"
   echo "( $(pwd)/rpi ) and try $(basename $0) again" 
   echo "Now exit"
   exit 1
else
   mkdir rpi
fi
echo "start transfer from ${FROM_USER}:${FROM_UPLOAD_DIR} to $(pwd) ......"
scp -P ${PORT} -r "${FROM_USER}:${FROM_UPLOAD_DIR}" $(pwd)
RET=$?
if [ $RET -ne 0 ];then
   echo "Could not access ${FROM_USER}:${FROM_UPLOAD_DIR}"
   echo "Not available. Now exit"
   rmdir $(pwd)/rpi
   exit 1
fi
echo "Now find your transferred files below $(pwd)/rpi"
exit $?

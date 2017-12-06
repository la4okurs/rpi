#!/bin/bash
#
# iNOTICE!!  Script status : Not finished, still more to code....
#
# Author: Steinar/LA7XQ
#
# This script transfers files through secure copy
#
# Notice!! Be sure to change your FROM_IP, USER and PORT before using this script
#
FROM_IP="192.168.0.237"
USER="pi"
PORT=37
SUBDIR="rpi"

usage_exit() {
   # transfer.bash pi@192.168.1.502 rpi/sub
   echo
   echo "Usage: $(basename $0)"
   echo "   or"
   echo "Usage: $(basename $0) <usr>@IP subdir"
   echo "ex1:   $(basename $0) ole@192.168.1.50 rpidir"
   echo "ex2:   $(basename $0) ole@192.168.1.50 /home/ole/rpidir # ILLEGAL"
   exit 1
}

COMPLETEPATH=0

if [ $# -ne 0 ];then
   [ $# -ne 2 ] && { echo "ERROR: Wrong format";usage_exit; }
   SUBDIR=""
   KROEL_FOUND=0
   for i in "$@";do
      echo "$i" | grep "\@"
      RET=$?
      if [ $RET -eq 0 ];then
         KROEL_FOUND=1
      fi  
   done
   [ $KROEL_FOUND -eq 0 ] && { echo "wrong format"; usage_exit; }
   COMPLETEPATH=1
   for i in "$@";do
      echo "ii=$i"
      echo "$i" | grep "\@"
      RET=$?
      if [ $RET -eq 0 ];then
         USER=$(echo "$i" | awk -F "@" '{print $1}')
         FROM_IP=$(echo "$i" | awk -F "@" '{print $2}')
         SUBDIR="$2"
         if [ ! "$(echo "$SUBDIR" | cut -c 1)" = "/" ];then
            COMPLETEPATH=0
         else
            echo "ERROR: input param <subdir> can not start with '\'"
            usage_exit 
         fi
         break
      fi  
   done
   [ -z "$SUBDIR" ] && { echo "sub directory to copy from is missing"; uasage_exit; }
fi

FROM_USER="${USER}@${FROM_IP}"
if [ $COMPLETEPATH -eq 0 ];then
   FROM_UPLOAD_DIR="/home/${USER}/${SUBDIR}"
else
   FROM_UPLOAD_DIR="${SUBDIR}"
fi
echo "FROM_USER=$FROM_USER"
echo "FROM_UPLOAD_DIR=$FROM_UPLOAD_DIR"

if [ "$FROM_IP" = "$(hostname -I | awk '{print $1}')" ]; then
   echo "This is your source host $(hostname -I)"
   echo "Do not try to destroy the source host"
   echo "Now exit"
   exit 1
fi
 
if [ -d $(pwd)/${SUBDIR} ];then
   echo "You have already an existing $(pwd)/${SUBDIR} directory"
   echo "I don't like to destroy any local files you have" 
   echo;echo "Please backup and the remove or move your local ${SUBDIR} directoryi"
   echo "( $(pwd)/${SUBDIR} ) and try $(basename $0) again" 
   echo "Now exit"
   exit 1
else 
   set -x
   echo ${SUBDIR} 
   if [ "$(echo "$SUBDIR" | cut -c 1)" = "/" ];then
      mkdir -p ${SUBDIR}
      RET=$?
   else
      mkdir -p ${HOME}/${SUBDIR}
      RET=$?
   fi
   set +x
   [ $RET -ne 0 ] && { echo "mkdir fails. Now exit";exit 1; }
fi
echo "start transfer from ${FROM_USER}:${FROM_UPLOAD_DIR} to $(pwd) ......"
set -x
if [ -d $(pwd)/${SUBDIR} ];then
   echo "You have already a directory called $(pwd)/${SUBDIR}"
   echo "I will not destroy it. Now exit"
   exit 1
fi
scp -P ${PORT} -r "${FROM_USER}:${FROM_UPLOAD_DIR}/*" $(pwd)/${SUBDIR}
RET=$?
set +x
if [ $RET -ne 0 ];then
   echo "Could not access ${FROM_USER}:${FROM_UPLOAD_DIR}"
   echo "Not available. Now exit"
   # rmdir $(pwd)/${SUBDIR}
   exit 1
fi
echo "Now find your transferred files below $(pwd)/${SUBDIR}"
exit $?

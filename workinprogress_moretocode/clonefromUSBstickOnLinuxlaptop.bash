#!/bin/bash
#
# Script status: Work in progress...., more code to be added
#
# Use this script to clone from the master USB stick mounted in the Linux Laptop
# or mounted on the RPI itself
# This script will copy also the bradio.bash and cradio.bash
# to the disk area (see below):
#
# example: 
# tobben@tobben-XPS-M1330 ~ $ bash ./clonefromUSBstickOnLinuxlaptop.bash
# /dev/sdb1                  2,0G  1,5M  2,0G   1% /media/tobben/0443-B119
# All files cloned from /media/tobben/0443-B119/rpi  to /home/tobben
# tobben@tobben-XPS-M1330 ~ $ 
#
# Author: Steinar/LA7XQ
#

SUBDIR="rpi"
if df -h | grep "\/media\/" ; then
   MEMSTIC_BASEDIR=$(df -h | grep "\/media\/" | awk '{print $NF}')
fi

#echo "MEMSTIC_BASEDIR=$MEMSTIC_BASEDIR"
#MEMSTIC_BASEDIR="/media/tobben/0443-B119"  # set it fixed?
if [ -z "$MEMSTIC_BASEDIR" ];then
   echo "MEMSTIC_BASEDIR is empty"
   echo "MEMSTIC_BASEDIR=$MEMSTIC_BASEDIR"
   echo
   echo "Is the USB not mounted?"
   echo "Try a 'df -h'"
   echo "No sense to continue. Now exit"
   exit 1
fi
if [ ! -d $MEMSTIC_BASEDIR ] ; then
   echo;echo "dir '${MEMSTIC_BASEDIR}' missing"
   echo "No sense to continue. Now exit"
   exit 1
fi
# echo "\$MEMSTIC_BASEDIR=$MEMSTIC_BASEDIR"
if [ -d ${HOME}/${SUBDIR} ] ; then
   echo;echo "dir '${HOME}/${SUBDIR}' exsists. I will not destroy it"
   echo "remove or rename the ${HOME}/${SUBDIR} first. Now exit"
   exit 1
fi
cp -r $MEMSTIC_BASEDIR/${SUBDIR} $HOME
RET=$?
if [ $RET -ne 0 ];then
   echo "cp -r $MEMSTIC_BASEDIR/${SUBDIR} $HOME    failed"
   exit 1
else
   echo "All files are now cloned from $MEMSTIC_BASEDIR/${SUBDIR} to $HOME/${SUBDIR}"
   echo "...Done"
   exit 0
fi

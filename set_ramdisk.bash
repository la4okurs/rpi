#!/bin/bash

#
# Author: Steinar/LA7XQ
#

MYRAMDISK="/dev/ram0"
MYMOUNTDIR="/mnt/rd"
MKE2FS="/sbin/mke2fs"
FDISK="/sbin/fdisk"

# cron:
# @reboot sudo bash $HOME/set_ramdisk.bash >/dev/null 2>&1
#

donothave_exit() {
   echo "$(basename $0) : Do not find $1"
   echo "Now exit"
   exit 1
}

optional() {
   $FDISK $MYRAMDISK -l
   ls -ld $MYRAMDISK $MYMOUNTDIR
   [ -f $MYMOUNTDIR/myfile ] && ls -ld $MYMOUNTDIR/myfile
   df $MYMOUNTDIR
}

set_access() {
   [ -e $MYRAMDISK ] && {
      /bin/chown -R root:disk $MYRAMDISK
      /bin/chmod 0660 $MYRAMDISK
   }
   [ -d $MYMOUNTDIR ] && {
      /bin/chown -R pi:root $MYMOUNTDIR
      /bin/chmod -R 0770 $MYMOUNTDIR
   }
   [ -f $MYMOUNTDIR/myfile ] && /bin/chown pi:root $MYMOUNTDIR/myfile
   [ -f $MYMOUNTDIR/myfile ] && /bin/chmod 770 $MYMOUNTDIR/myfile
}

if [ $(id -u) -ne 0 ];then
   echo "Please run this script from root (using 'sudo bash $(basename $0)' if possible)"
   exit 1
fi 

# umount/delete if exists...
[ -d $MYMOUNTDIR ] && umount $MYMOUNTDIR
[ -d $MYRAMDISK ]  && umount $MYRAMDISK
[ -d $MYMOUNTDIR ] && rm -rf $MYMOUNTDIR

# establish now....
[ -f $MKE2FS ] || donothave_exit $MKE2FS
[ -f $FDISK ]  || donothave_exit $FDISK
rm -f $MYMOUNTDIR
rm -f $MYRAMDISK
mknod $MYRAMDISK  b 1 0
$MKE2FS -q -F -m 0 $MYRAMDISK
set_access

[ -d $MYMOUNTDIR ] || mkdir $MYMOUNTDIR
/bin/mount $MYRAMDISK $MYMOUNTDIR
# ------ now dir $MYMOUNTDIR is established and mounted ------ use it -------

# test --- example of usage ----- :
uname -a >$MYMOUNTDIR/myfile
date >> $MYMOUNTDIR/myfile
set_access
optional
exit 0

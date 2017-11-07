#!/bin/bash -e
#
# This program I made if you are running recent versions of Linux Raspbian distro (stretch)
# to quickly alter the upper 24 bits of your LAN IPv4 IP address base.
# The /etc/dhcpcd.conf file is used for IP configs in stretch versions
# For help, simply start the script with no arguments given
#
# Advice: Do not change the IP base if not knowing your present base
#         For a post control after chaning the IP base, you may find the 'getip' program useful 
#
# Author: Steinar Wenaas/LA7XQ
#

FILE="/etc/dhcpcd.conf"  # file that defines IP addresses in late Raspians
BASEWIFI_0="192.168.0"
BASEWIFI_1="192.168.1"
NEWFILE=${FILE}.$(basename $0)
usage_exit() {
    echo "ERROR: Usage: $(basename $0) <convert_to_base>"
    echo "ERROR:        <convert_to_base> is either 192.168.0 or 192.168.1"
    exit 1
}
if [ $# -ne 1 ];then
    usage_exit
fi
if [ "$1" = "$BASEWIFI_0" ];then
   :
elif [ "$1" = "$BASEWIFI_1" ];then
   :
else
   usage_exit
fi

if [ ! -f $FILE ];then
   echo "$(basename $0): can't find $FILE"
   echo "No sense to continue, now exit"
   exit 1;
else
   if ! cp $FILE ${NEWFILE};then
      echo "Can not cp $FILE ${NEWFILE}. Now exit"
      exit 1
   fi
fi
CONVERTTO="$1"

if grep -q "$BASEWIFI_0" $FILE; then
   ls -ld ${NEWFILE}
   sed -i -e "s/$BASEWIFI_0/$CONVERTTO/g" ${NEWFILE}
   ls -ld ${NEWFILE}
fi
if grep -q "$BASEWIFI_1" $FILE; then
   ls -ld ${NEWFILE}
   sed -i -e "s/$BASEWIFI_1/$CONVERTTO/g" ${NEWFILE}
   ls -ld ${NEWFILE}
fi
echo "============"
echo "grep:"
grep -i "$BASEWIFI_1" $NEWFILE
echo "============"
echo "grep:"
grep -i "$BASEWIFI_0" $NEWFILE
ls -ld $NEWFILE
echo "Now do 'sudo cp $NEWFILE /etc/dhcpcd.conf'"
echo "and then 'sudo reboot'"
exit 0



FILE="/etc/dhcpcd.conf" #!/bin/bash -e
FILE="/etc/dhcpcd.conf"  # file that defines IP addresses in late Raspians
BASEWIFI_0="192.168.0"
BASEWIFI_1="192.168.1"
NEWFILE=${FILE}.$(basename $0)
usage_exit() {
    echo "ERROR: Usage: $(basename $0) <convert_to_base>"
    echo "ERROR:        <convert_to_base> is either 192.168.0 or 192.168.1"
    exit 1
}
if [ $# -ne 1 ];then
    usage_exit
fi
if [ "$1" = "$BASEWIFI_0" ];then
   :
elif [ "$1" = "$BASEWIFI_1" ];then
   :
else
   usage_exit
fi

if [ ! -f $FILE ];then
   echo "$(basename $0): can't find $FILE"
   echo "No sense to continue, now exit"
   exit 1;
else
   if ! cp $FILE ${NEWFILE};then
      echo "Can not cp $FILE ${NEWFILE}. Now exit"
      exit 1
   fi
fi
CONVERTTO="$1"

if grep -q "$BASEWIFI_0" $FILE; then
   ls -ld ${NEWFILE}
   sed -i -e "s/$BASEWIFI_0/$CONVERTTO/g" ${NEWFILE}
   ls -ld ${NEWFILE}
fi
if grep -q "$BASEWIFI_1" $FILE; then
   ls -ld ${NEWFILE}
   sed -i -e "s/$BASEWIFI_1/$CONVERTTO/g" ${NEWFILE}
   ls -ld ${NEWFILE}
fi
echo "============"
echo "grep:"
grep -i "$BASEWIFI_1" $NEWFILE
echo "============"
echo "grep:"
grep -i "$BASEWIFI_0" $NEWFILE
ls -ld $NEWFILE
echo "Now do 'sudo cp $NEWFILE /etc/dhcpcd.conf'"
echo "and then 'sudo reboot'"
exit 0


 # file that defines IP addresses in late Raspians
BASEWIFI_0="192.168.0"
BASEWIFI_1="192.168.1"
NEWFILE=${FILE}.$(basename $0)
usage_exit() {
    echo "ERROR: Usage: $(basename $0) <convert_to_base>"
    echo "ERROR:        <convert_to_base> is either 192.168.0 or 192.168.1"
    exit 1
}
if [ $# -ne 1 ];then
    usage_exit
fi
if [ "$1" = "$BASEWIFI_0" ];then
   :
elif [ "$1" = "$BASEWIFI_1" ];then
   :
else
   usage_exit
fi

if [ ! -f $FILE ];then
   echo "$(basename $0): can't find $FILE"
   echo "No sense to continue, now exit"
   exit 1;
else
   if ! cp $FILE ${NEWFILE};then
      echo "Can not cp $FILE ${NEWFILE}. Now exit"
      exit 1
   fi
fi
CONVERTTO="$1"

if grep -q "$BASEWIFI_0" $FILE; then
   ls -ld ${NEWFILE}
   sed -i -e "s/$BASEWIFI_0/$CONVERTTO/g" ${NEWFILE}
   ls -ld ${NEWFILE}
fi
if grep -q "$BASEWIFI_1" $FILE; then
   ls -ld ${NEWFILE}
   sed -i -e "s/$BASEWIFI_1/$CONVERTTO/g" ${NEWFILE}
   ls -ld ${NEWFILE}
fi
echo "============"
echo "grep:"
grep -i "$BASEWIFI_1" $NEWFILE
echo "============"
echo "grep:"
grep -i "$BASEWIFI_0" $NEWFILE
ls -ld $NEWFILE
echo "Now do 'sudo cp $NEWFILE /etc/dhcpcd.conf'"
echo "and then 'sudo reboot'"
exit 0

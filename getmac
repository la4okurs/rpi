#!/bin/bash
#
# The program gives overview over vendors on the MAC addresses found
# on local network
# Run the program as sudo
#
# Author: Steinar/LA7XQ
#

TMP1="./arp.tmp1"
OUIFILE="./oui.txt"

if [ ! -f $OUIFILE ];then
   echo "$(basename $0):ERROR: File $OUIFILE not found"
   echo "Perform first an '\$ wget http://standards.ieee.org/develop/regauth/oui/oui.txt' on this directory"
   echo "Now exit"
   exit 1
fi

sudo arp-scan --retry=6 --ignoredups --localnet > $TMP1

RET=$?
[ $RET -ne 0 ] && { echo "$(basename $0): ERROR: Can't arp scan. Can't connect to network"; exit 1; }
while IFS='' read -r line || [[ -n "$line" ]]; do
    if echo $line | grep -q -E ":.*:.*:.*:";then
       printf $(echo "$line" | awk '{print $1}')
       printf "   "
       MAC=$(echo "$line" | awk '{print $2}')
       OUI=$(echo ${MAC//[:.- ]/} | tr "[a-f]" "[A-F]" | egrep -o "^[0-9A-F]{6}")
       OUUT=$(grep "$OUI" $OUIFILE) # wget http://standards.ieee.org/develop/regauth/oui/oui.txt

       printf " "
       grep "$OUUT" $OUIFILE # wget http://standards.ieee.org/develop/regauth/oui/oui.txt
    fi
done < "$TMP1"
[ -f $TMP1 ] && rm -f $TMP  # cleanup

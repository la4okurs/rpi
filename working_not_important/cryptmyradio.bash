#!/bin/bash
TMP_SER="./tmp_ser"
TMP_SER_SHA="${TMP_SER}.sha256sum"

TMP_PASSWD="./tmp_la7xpasswd"
TMP_PASSWD_SHA="${TMP_PASSWD}.sha256sum"

TMP_OWNER="./tmp_owner"
TMP_OWNER_SHA="${TMP_OWNER}.sha256sum"

TMP_RES="./tmp_myradio"
TMP_RES_SHA="${TMP_RES}.sha256sum"

TMP_SER_TMP1="./tmp_ser_tmp1"
TMP_PASSWD_TMP2="./tmp_passwd_tmp2"
TMP_OWNER_TMP3="./tmp_owner_tmp3"

MYRADIO_KEY="${TMP_RES}.sha256sum"
MYRADIO_PUB_KEY="./myradio_pub_key"   # to publish
MYRADIO_PRIV_KEY="./myradio_priv_key" # keep private

TMPS="$TMP_SER $TMP_SER_SHA $TMP_PASSWD $TMP_PASSWD_SHA $TMP_RES $TMP_RES_SHA $TMP_OWNER $TMP_OWNER_SHA $TMP_SER_TMP1 $TMP_PASSWD_TMP2 $TMP_OWNER_TMP3 $MYRADIO_KEY $MYRADIO_PUB_KEY $MYRADIO_PRIV_KEY"

TMPS_NOT_KEYFILES="$TMP_SER $TMP_SER_SHA $TMP_PASSWD $TMP_PASSWD_SHA $TMP_RES $TMP_RES_SHA $TMP_OWNER $TMP_OWNER_SHA $TMP_SER_TMP1 $TMP_PASSWD_TMP2 $TMP_OWNER_TMP3"

SHASUM="/usr/bin/sha256sum"
LA7XPASSWD="abc"  # not to be used anyhow

isRPI() {
   # return 0 if its a RPI
   if cat /proc/cpuinfo | grep -q -i -E 'Hardware.*BCM2'; then
     if cat /proc/cpuinfo | grep -q -i -E "(^model name.*ARMv6-compatible processor|ARMv7.*processor)";then
        return 0
     fi
   fi
   return 1
}

cleanup() {
   for i in $TMPS;do
      rm -f $i
   done
}

cleanupNotkeyfiles() {
   for i in $TMPS_NOT_KEYFILES; do
      rm -f $i
   done
}

gen_sha() {
   # needs arg1
   # return 0 if success, 1 otherwise
   #ls -ld $1
   if [ ! -f "$1" ];then
      echo "gen_sha: File '$1' empty. Can not generate sha256sum"
      return 1
   fi
   if [ "$(wc -c "$1" | awk '{print $1}')" -eq 0 ];then
      echo "gen_sha: WARNING: file $1 is emppty !!"
      return 1
   fi
   $SHASUM $1 >${1}.sha256sum
   RET=$?
   return $RET
}

invesigateFile() {
   if [ ! -f "$1" ];then
      echo "invesigateFile: Can not find file '$1'"
      return 1
   fi
   if [ "$(wc -c "$1" | awk '{print $1}')" -eq 0 ];then
      echo "gen_sha: WARNING: file $1 is emppty !!"
      return 1
   fi
}

dumpfileToScreen() {
   invesigateFile "$1"
   echo;echo "------ start of $1 ------"
   cat $1
   RET=$?
   echo "------ end of $1 ------"
   return $RET
}

usage_exit() {
   echo "Usage ERROR"
   echo "Usage: '$(basename $0) RPIowner <la7xpasswd>'"
   echo "Example1: '$(basename $0) per_olsen <\$LA7XPASSWD>"
   echo "Example2: '$(basename $0) per@online.no <\$LA7XPASSWD>"
   cleanup
   exit 1
}

echo_totfiles() {
   # add an arg1 to caller if WARNING wanted
   echo "totfiles:"
   for i in $TMPS;do
      ls -ld $i
      cat $i
   done 
}

establish_files() {
   for i in $TMPS;do
      rm -f $i
      touch $i
   done
}

isRPI
RET=$?
if [ $RET -ne 0 ];then
   echo "ERROR: This host ($(hostname)) is likely not an RPI"
   echo "You should run this script on an RPI only"
   echo "Now exit"
   exit 1
fi

if [ $# -ne 1 -a $# -ne 2 ];then
   usage_exit
else
   if [ $# -eq 1 ];then
      # redefine....
      OWNER="$1"
   else
      #eq 2 
      OWNER="$1"
      LA7XPASSWD="$2"
   fi
fi

if [ ! -f $SHASUM ];then
   echo "$(basename $0):ERROR: $SHASUM missing"
   echo "To be installed first."
   echo "Now exit"
   cleanup
   exit 1
fi

#echo_totfiles nowarning
cleanup
#echo_totfiles nowarning
establish_files
#echo_totfiles nowarning

cat /proc/cpuinfo | grep Serial | awk '{print $NF}' >$TMP_SER
gen_sha $TMP_SER
RET=$?

echo "$OWNER" > $TMP_OWNER
gen_sha $TMP_OWNER
RET=$?

#echo_totfiles nowarning

echo "$LA7XPASSWD" > $TMP_PASSWD
gen_sha $TMP_PASSWD
RET=$?
#echo_totfiles nowarning

#echo_totfiles

cat $TMP_SER_SHA    | awk '{print $1}' > $TMP_SER_TMP1
cat $TMP_PASSWD_SHA | awk '{print $1}' > $TMP_PASSWD_TMP2
cat $TMP_OWNER_SHA  | awk '{print $1}' > $TMP_OWNER_TMP3

cat $TMP_SER_TMP1 $TMP_PASSWD_TMP2 $TMP_OWNER_TMP3 > $TMP_RES

gen_sha $TMP_RES
RET=$?
#echo_totfiles nowarning

MYRADIO_KEY=$(cat ${TMP_RES}.sha256sum | awk '{print $1}')
#echo "MYRADIO_KEY=$MYRADIO_KEY"
SERIAL=$(cat $TMP_SER | head -n 1)
rm -r $MYRADIO_PUB_KEY
rm -r $MYRADIO_PRIV_KEY

echo "$OWNER $SERIAL $MYRADIO_KEY" >$MYRADIO_PUB_KEY
echo "RPIowner RPI_Serialno     Myradio_pub_key                                                  la7xqpasswd genearted_by" >$MYRADIO_PRIV_KEY

echo "$OWNER    $SERIAL $MYRADIO_KEY $LA7XPASSWD   $(whoami)@$(hostname):$(pwd)/$(basename $0)" >>$MYRADIO_PRIV_KEY
if [ -f $MYRADIO_PUB_KEY ];then
   echo;echo "success: generated key to publish in public file '$MYRADIO_PUB_KEY'"
   invesigateFile $MYRADIO_PUB_KEY
else
   echo "$(basename $0): ERROR: $MYRADIO_PUB_KEY to publish not generated OK"
   cleanupNotkeyfiles
   exit 1
fi
if [ -f $MYRADIO_PRIV_KEY ];then
   echo "success: generated key NOT to publish in private file '$MYRADIO_PRIV_KEY'"
   invesigateFile $MYRADIO_PRIV_KEY
else
   echo "$(basename $0): ERROR: $MYRADIO_PRIV_KEY to publish not generated OK"
   cleanupNotkeyfiles
   exit 1
fi
cleanupNotkeyfiles # every file expect $MYRADIO_PUB_KEY and $MYRADIO_PRIV_KEY

echo;echo "optional dump block:"
dumpfileToScreen $MYRADIO_PUB_KEY
RET=$?
dumpfileToScreen $MYRADIO_PRIV_KEY
RET=$?

exit $RET # test only last

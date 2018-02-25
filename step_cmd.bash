#!/bin/step
usage_exit() {
   echo "Usage: $(basename $0) <cmdfile>"
   exit 1
}
if [ $# -ne 1 ];then
   usage_exit
fi
INFILE="$1"
if [ -f $INFILE ];then
   :
else
#cat << EOF >$INFILE
#uname
#who
#whoami
#EOF
   echo "$INFILE missing"
   exit 1
fi

cat $1
echo;echo
echo "------now running one cmd after another -- press ENTER -----:"
LINE=0
while true;do
   LINE=$((LINE+1))
   CMD="$(sed -n ${LINE},${LINE}p $INFILE)"
   RET=$?
   echo -ne "${LINE}: "
   if [ -z "$CMD" ];then
      echo
      NOLINES=$(wc -l $INFILE | awk '{print $1}')
      if [ $LINE -lt $NOLINES ];then
         continue
      else
         break
      fi
   else
      echo -ne "   $CMD"
      read 
      eval "$CMD"
      RET=$?
      if [ $RET -ne 0 ];then
         echo "ERROR? RET=$RET"
      fi
   fi
done
exit 0

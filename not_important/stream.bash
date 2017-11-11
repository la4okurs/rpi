
#/bin/bash
#
# Just a quick hack script to quickly test my new wonderful Raspberry Pi based
# IQAUDIO sound card
#
# Author: Steinar/LA7XQ
#
VLC_LISTENVHF_PATH="/home/pi/rpi"
RADIOLIST="./radiolist"

question() {
   # call like this:
   # QUESTION="Select one of the following"
   # POSANS="nrk p4 ham john status stop" 
   # question "$QUESTION" "$POSANS"
   # question "$QUESTION" "$POSANS" "$ARG" # format used no question is wanted,
   #                                       # when answer is already selected as third argument
   #                                       # when caller is like 'bash thisscript yes'
   # RET=$?
   # echo "ANS=$ANS"
   # echo "RET=$RET"
   # out: ANS  # answer
   #
   while true;do
      [ -z "$3" ] && echo "$1"  # the question
      for i in $2 ;
      do
         # echo  $i
         echo -ne "$i, "
      done
      if [ -z "$3" ];then
         echo
         # echo -ne "Your answer: "
         read ANS
      else
         ANS=$3
      fi
      #echo "ANS=$ANS"
      FOUND=0
      for i in $2;
      do
         if [ "$ANS" = "$i" ];then
            echo;echo "You selected '$ANS'"
            FOUND=1
            return 0
            break # as found
         fi
      done
      if [ $FOUND -ne 1 ];then
         echo
         if [ -z "$3" ];then
            echo "'$ANS' is not in the list. Please again:"
            continue 
         else
            echo "ERROR: The given '$3' is not allowed."
            ANS="illegal" 
            return 1
            break 
         fi 
      fi
   done
}

readanddisplayfile() {
   # call function like this: 'readanddisplayfile file'
   # filename in $1
   if [ -z "$1" ];then
      echo "readanddisplayfile(): no file specified"
      return 1
   fi
   [ -f $1 ] || { echo "No such file '$1'"; return 1; }
   while read line; do    
      echo $line    
   done < $1
   return 0
}

buildposanswers() {
   # call function like this: 'buildposanswers file'
   # filename in $1
   if [ -z "$1" ];then
      echo "buildposanswers(): no file specified"
      return 1
   fi
   [ -f $1 ] || { echo "buildposanswers():No such file '$1'"; return 1; }
   
   TMPRESFILE1="./.tmp1"
   TMPRESFILE2="./.tmp2"
   [ -f $TMPRESFILE1 ] && rm $TMPRESFILE1
   [ -f $TMPRESFILE2 ] && rm $TMPRESFILE2
   while read line; do    
      colen=$(echo $line  | awk '{print $1}')
      # echo "colen=${colen}X"
      if [ ! "$colen" = "#" ];then
         # echo $line  | awk '{print $1}' >>$TMPRESFILE1
         echo $colen >>$TMPRESFILE1
      fi
   done < $1
   # replace NL wit SP
   tr '\n' ' ' < $TMPRESFILE1 >$TMPRESFILE2
   mv $TMPRESFILE2 $TMPRESFILE1
   cat $TMPRESFILE1
   return 0
}

pickalineandplay() {
   # call function like this: 'pickalineandplay file'
   # filename in $1
   if [ -z "$1" ];then
      echo "pickalineandplay(): no file specified"
      return 1
   fi
   if [ -z "$2" ];then
      echo "ERROR: pickalineandplay(): This call has two arguments"
      return 1
   fi
   [ -f $1 ] || { echo "No such file '$1'"; return 1; }
   touch "./.tmp1"
  
   echo "reading the $1  file..."
   FOUND=0
   while read line; do    
      col1=$(echo $line  | awk '{print $1}')
      # echo "==>col1=$col1"
      if [ "$col1" = "$2" ];then
         FOUND=1 
         #echo "line=$line"
         http=$(echo "$line" | sed -e 's/.*http:/http:/g' -e 's/#.*//g' )
         # echo "http=$http"
         # echo "==>COL1=$col1, line=$line"

         # treat some entries as proprietary:
         if [ "$col1" == "ham" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash start &"
         elif [ "$col1" == "start" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash start &"
         elif [ "$col1" == "stop" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash stop &"
         elif [ "$col1" == "status" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash status"
         else
            #play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash ""http://streaming.radio.co/s9fa0dff72/listen  start &"
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash ""$http start &"
         fi
         echo "now doing '$play'"
         eval "$play"
         return 0
      fi
   done < $1
   return 1
}

# echo "Reading the $RADIOLIST ..."
POSANS=$(buildposanswers $RADIOLIST)
QUESTION="Select one of the following"
question "$QUESTION" "$POSANS" "$1"
RET=$?
# echo "ANS=$ANS"; exit 0
[ $RET -ne 0 ] && { echo "ERROR: Answer was ${ANS}, now exit";exit 1; }
pickalineandplay $RADIOLIST "$ANS"
RET=$?
exit $RET



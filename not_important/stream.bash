#/bin/bash
#
# Just a quick hack script to quickly test my new wonderful Raspberry Pi based
# IQAUDIO sound card
#
# Author: Steinar/LA7XQ
#
FIRSTLETTER=$(echo $(dirname $0) | cut -c1)
if [ "$FIRSTLETTER" = "/" ];then
   PATH_CALLEDPROG=$(dirname $0)
else
   PATH_CALLEDPROG=$(pwd)/$(dirname $0)
fi
RADIOLISTFILE=${PATH_CALLEDPROG}/radiolist

# vlc_listenvhf.bash is one above directory relative to this program:
VLC_LISTENVHF_PATH="${PATH_CALLEDPROG}/.."
GUI=""

question() {
   # call like this:
   # #QUESTION=""
   # QUESTION="Select one of these:"
   # question "$QUESTION" "yes no" "$1"
   # question "$QUESTION" "$POSANS" "$1"
   # RET=$?
   ## out: ANS  # answer
   # echo "ANS=$ANS"; exit 0
   #
   while true;do
      # if [ -z "$3" ];then
      if [ -z "$1" ];then
          echo;echo "Select one of the following:"
      else
          echo;echo "$1"  # the question
      fi
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
            echo
            echo -ne "You selected '$ANS'"
            [ -z "$GUI" ] || echo -ne " and vlc GUI will show up.(Notice: Running without GUI saves a lot of CPU cycles!)"
            echo
            FOUND=1
            return 0
            break # as found
         fi
      done
      if [ $FOUND -ne 1 ];then
         echo
         if [ -z "$3" ];then
            echo "'$ANS' is not in the list. Please again:"
            if [ "$ANS" = "gui" ];then
               echo "I'll turn on the play bar as well for you now...."
               GUI=$ANS
            fi
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
   # routine currently not in use
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
      POS1=$(echo "$line" | cut -c1)
      [ "$POS1" = "#" ] && continue
      [ "$POS1" = "" ] && continue # new
      colen=$(echo $line | awk -F "::" '{print $1}')
      # echo "colen=${colen}X"
      # echo $line  | awk -F "::" '{print $1}' >>$TMPRESFILE1
      echo $colen >>$TMPRESFILE1
   done < $1
   tr '\n' ' ' < $TMPRESFILE1 >$TMPRESFILE2 # replace /n with SP
   mv $TMPRESFILE2 $TMPRESFILE1
   cat $TMPRESFILE1
   rm  $TMPRESFILE1 # cleanup
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
  
   echo "reading the $1 file..(try also the '$ bash $(basename $0) list' ):"
   FOUND=0
   while read line; do    
      POS1=$(echo "$line" | cut -c1)
      [ "$POS1" = "#" ] && continue
      [ "$POS1" = "" ] && continue # new
      col1=$(echo $line | awk -F "::" '{print $1}' | awk '{print $1}')
      [ -z "$col1" ] && continue
      if [ "$col1" = "$2" ];then
         FOUND=1
         if echo "$line" | grep "http:"; then
            HTTP=$(echo "$line" | sed -e 's/.*http:/http:/g' -e 's/#.*//g' ) # http
         fi
         if echo "$line" | grep "rtmp:"; then
            HTTP=$(echo "$line" | sed -e 's/.*rtmp:/rtmp:/g' -e 's/#.*//g' ) # rtmp
         fi
         # echo "HTTP=$HTTP"
         # treat some entries in $RADILIST as proprietary:
         if [ "$col1" == "start" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash start $GUI &"
         elif [ "$col1" == "stop" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash stop &"
         elif [ "$col1" == "status" ];then
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash status"
         elif [ "$col1" == "list" ];then
            if [ -f $RADIOLISTFILE ];then
               cat $RADIOLISTFILE
               return 0
            else
               echo "Can't find the $RADIOLISTFILE"
               return 1
            fi
         else
            play="bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash ""\"$HTTP\" start $GUI &"
         fi
         echo "now doing '$play'"
         eval "$play"
         return 0
      fi
   done < $1
   return 1
}

# echo "Reading the $RADIOLISTFILE ..."
POSANS=$(buildposanswers $RADIOLISTFILE)
 
#QUESTION="" # gives std routine question is left empty
QUESTION="Select one below to stream. Type 'gui' if GUI wanted, 'stop' to stop.(4 first are control):"
question "$QUESTION" "$POSANS" "$1"
RET=$?
[ $RET -ne 0 ] && { echo "ERROR: Answer was ${ANS}, now exit";exit 1; }
pickalineandplay $RADIOLISTFILE "$ANS"
RET=$?
exit $RET

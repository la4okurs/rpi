
#/bin/bash
#
# Just a quick hack script to quickly test my new wonderful Raspberry Pi based
# IQAUDIO sound card
#
# Author: Steinar/LA7XQ
#
VLC_LISTENVHF_PATH="/home/pi/rpi"
MYLIST="nrk p4 ham john status stop"
while true;do
   if [ $# -eq 0 ];then
      echo "Select one of the following:"
      for i in $MYLIST;
      do
         echo $i
      done
      echo
      echo -ne "Your answer: "
      read ANS
      #echo "ANS=$ANS"
      FOUND=0
      for i in $MYLIST;
      do
         if [ "$ANS" = "$i" ];then
            FOUND=1
            ARG=$ANS
            break # as found
         fi
      done
      if [ $FOUND -eq 0 ];then
         echo;echo "Not in the list. Please again:"
         continue
      fi
   else
      ARG="$1"
      break
   fi
   if [ $FOUND -eq 1 ];then
      break
   fi
done

echo "You selected: ${ARG}. Just a second...."

if [ "$ARG" = "john" ];then
   bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash http://streaming.radio.co/s9fa0dff72/listen  start &
elif [ "$ARG" = "p4" ];then
   # bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash http://streaming.radio.co/s9fa0dff72/listen  start &
   bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash http://stream.p4.no/p4_mp3_hq start &
elif [ "$ARG" = "nrk" ];then
   bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash http://nrk-mms-live.telenorcdn.net:80/nrk_radio_p13_aac_h start &
elif [ "$ARG" = "ham" ];then
   bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash start &
elif [ "$ARG" = "status" ];then
   bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash status
elif [ "$ARG" = "stop" ];then
   bash ${VLC_LISTENVHF_PATH}/vlc_listenvhf.bash stop
else
   :
fi
exit 0






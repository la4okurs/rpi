#!/bin/bash
#
# Author: Steinar/LA7XQ
#
# This script adds code to the $HOME/.bashrc file
# in order to set execute access on the $HOME/rpi/*   files
# and add the $HOME/rpi/  directory to the PATH environment
#

if [ ! -f $HOME/.bashrc ];then
   touch $HOME/.bashrc
fi
if grep -q -E "export PATH=.*HOME/rpi" $HOME/.bashrc;then
   echo "Seems that you have already run this script"
   echo "ignored now, exit done"
   echo "If you still want to execute this script, remove the SWE added section in $HOME/.bashrc first"
   exit 0
fi

cat << EOF >> $HOME/.bashrc    
#---- SWE added block starts -----
if [ -d \$HOME/rpi ];then
   if ! echo "\$PATH" | grep -q -oE "\$HOME/rpi" ;then
      # echo "Now export....# SWE added line" # SWE added line
      export PATH=\$PATH:\$HOME/rpi   # SWE added line
   fi
   chmod u+x \$HOME/rpi/*  # SWE added line, no harm if done repeatedly
fi
#---- SWE added block ends -----
EOF
echo "INFO: IMPORTANT: Now relogin $(whoami) (do 'sudo login $(whoami)') or reboot your system"
echo "                 in order to have the new settings in action"
exit 0

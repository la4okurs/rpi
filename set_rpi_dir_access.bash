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
#ls -ld $HOME/.bashrc
cat << EOF > $HOME/.bashrc    
#---- SWE added block starts -----
if [ -d \$HOME/rpi ];then
   if ! echo "\$PATH" | grep -q -oE "\$HOME/rpi" ;then
      # echo "Now export....# SWE added line" # SWE added line
      export PATH=\$PATH:\$HOME/rpi   # SWE added line
   else
      :
      # echo "Now DO NOT export PATH...# SWE added line" # SWE added line
   fi
   chmod u+x \$HOME/rpi/*  # SWE added line, no harm if done repeatedly
fi
# echo "Now PATH is '\$PATH' # SWE added line" # SWE added line
#---- SWE added block ends -----
EOF
echo "INFO: IMPORTANT: Now relogin $(whoami) or reboot your system"
echo "                 in order to have the new settings in action"
exit 0


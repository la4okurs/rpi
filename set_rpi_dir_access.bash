#!/bin/bash
#
# Author: Steinar/LA7XQ
#
# This script adds code to the $HOME/.bashrc file
# in order to set execute access on the $HOME/rpi/get*   files
# and add the $HOME/rpi/  directory to the PATH environment
#

if [ ! -f $HOME/.bashrc ];then
   mkdir -p $HOME/.bashrc
fi
#ls -ld $HOME/.bashrc
if ! cat $HOME/.bashrc | grep -q -E "if .*set_rpi_dir_access.bash";then
   echo "# SWE added:" >> $HOME/.bashrc
   echo "if [ -f \$HOME/rpi/set_rpi_dir_access.bash ];then" >> $HOME/.bashrc
   echo ". \$HOME/rpi/set_rpi_dir_access.bash" >>$HOME/.bashrc
   echo "fi" >>$HOME/.bashrc
   echo "INFO: New last part of $HOME/.bashrc set as:"
   cat $HOME/.bashrc | tail -n 5
fi   

# avoid appending multiple same directory $HOME/rpi to the final PATH:
if ! echo $PATH | grep -q -E "$HOME/rpi";then
   [ -d "$HOME/rpi" ] && export PATH="$PATH:$HOME/rpi"
   sudo chmod a+rx $HOME/rpi/get*
   echo "INFO:New PATH updated as '$PATH'"
fi
echo "INFO:"
echo "You should now be able to type simply 'getip', 'getrpimodel' etc"
echo "from any pi directory"
exit 0

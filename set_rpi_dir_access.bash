#!/bin/bash
#
# Author: Steinar/LA7XQ
#

# directions:
# leave next commented block as a none commented code in the
# last part of the $HOME/.bashrc   file :
#
#if [ -f $HOME/rpi/set_rpi_dir_access.bash ];then
#   . $HOME/rpi/set_rpi_dir_access.bash
#fi
#
# Do not copy the next lines to the $HOME/.bashrc  file:
if ! echo $PATH | grep -q -E "$HOME/rpi";then
   export PATH="$PATH:$HOME/rpi"
fi
sudo chmod a+rx $HOME/rpi/get*

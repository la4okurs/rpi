#!/bin/bash

# SWE: add next lines from next block to the .bashrc file ------
# SWE: added lines to the .bashrc file stops ------
#if [ -f $HOME/rpi/set_rpi_dir_access.bash ];then
#   . $HOME/rpi/set_rpi_dir_access.bash
#fi
# SWE: added lines to the .bashrc file stops ------

# Do not copy the next lines to the $HOME/.bashrc  file:
export PATH="$PATH:$HOME/rpi"
sudo chmod u+x $HOME/rpi/get*

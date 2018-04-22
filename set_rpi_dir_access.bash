#!/bin/bash

# SWE: add two next active lines to the .bashrc file ------
# SWE: added lines to the .bashrc file starts ------
echo "SWE:I am your .bashrc file"
[ -f ./rpi/set_rpi_dir_access.bash ] && source ./rpi/set_rpi_dir_access.bash
# SWE: added lines to the .bashrc file starts ------

export PATH="$PATH:$HOME/rpi"
chmod u+x $HOME/rpi/get*

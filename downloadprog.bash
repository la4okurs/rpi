#!/bin/bash
# 
# This script downloads a raw single file from the
# github la4okurs area: https://github.com/la4okurs/rpi/master area
#
# Author: Steinar/LA7XQ
#
#
#

THISSCRIPT=$(basename $0)

usage_exit() {
   echo "Usage:   $ bash $THISSCRIPT <filename>  # Notice: give no path to file"
   echo "Usage:   $ bash $THISSCRIPT --help"
   echo "Example: $ bash $THISSCRIPT listenvhf.bash  # As seen, no path given"
   exit 0
}

if [ $# -eq 0 ];then
   echo ""
   echo "ERROR: You forgot to specify which file to download"
   usage_exit
fi

case $1 in
   --help|-h|--h)
      usage_exit
      ;;
   *) CMD="wget https://raw.github.com/la4okurs/rpi/master/$1"
      echo "$CMD"
      echo
      $CMD
      RET=$?
      if [ $RET -ne 0 ];then
         echo "$(basename $0): file '$1' not found or connection lost"
      fi
      ;;
esac


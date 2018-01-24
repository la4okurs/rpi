#!/bin/bash
# 
# This script downloads a raw single file from the
# github la4okurs area: https://github.com/la4okurs/rpi/master area
#
# Author: Steinar/LA7XQ
#

THISSCRIPT=$(basename $0)
WGET=/usr/bin/wget

usage_exit() {
   echo "Usage:   $ bash $THISSCRIPT <filename>  # Notice: Do not use path to file"
   echo "Usage:   $ bash $THISSCRIPT --help"
   echo "Example: $ bash $THISSCRIPT getip       # As seen, no path given"
   exit 0
}


# Check that 1 argument is used when calling the script
if [ $# -eq 0 ];then
   echo ""
   echo "ERROR: You forgot to specify which file to download"
   usage_exit
fi


# Check if the program 'wget' is present as this script is using the wget program
# Exit if not found
if [ ! -f $WGET ];then
   echo "ERROR: Can not find the program $WGET"
   echo "       Install it by  giving 'sudo apt-get install wget'"
   exit 1
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
         exit 1
      else
         exit 0
      fi
      ;;
esac

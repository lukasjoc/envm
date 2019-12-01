#!/usr/local/bin/bash

# Checking the $ENVM_WDIR variable which contains the path to our synced working dir
if [ $ENVM_PATH == "" ]; then
  export ENVM_WDIR="$HOME/Sync/"
fi

if [ $ENVM_AUTO_UPDATE == 1 ]; then
  if [[ ! -e /tmp/.envm ]] || test $(find /tmp/.envm -type f -mmin +480) ; then
    cd $envm
    echo "Updating envm..."
    git checkout master
    git pull
    touch /tmp/.envm
  fi
fi

source "$envm/scripts/aliases.sh"
source "$envm/scripts/functions.sh"

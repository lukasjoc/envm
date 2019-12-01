#!/usr/local/bin/bash

# Checking the $ENVM_WDIR variable which contains the path to the synced working dir
if [[ $ENVM_WDIR == "" ]]; then
  export ENVM_WDIR="$HOME/Sync/"
fi

# Check for AUTO_UPDATE Variavle and update if changes have been detected
if [[ $ENABLE_ENVM_AUTO_UPDATE == "true" ]]; then
  if [[ ! -e /tmp/.envm ]] || test $(find /tmp/.envm -type f -mmin +480) ; then
    cd $ENVM
    echo "Updating envm..."
    git checkout master
    git pull
    touch /tmp/.envm
  fi
fi

source "$ENVM/scripts/aliases.sh"
source "$ENVM/scripts/functions.sh"

#!/usr/local/bin/bash

# Load and source all scripts, means functions, aliases, plugins etc
for script in "$ENVM/scripts/*"; do
  source $script
done

# Checking the $ENVM_WDIR variable which contains the path to the synced working dir
if [[ $ENVM_WDIR == "" ]]; then
  export ENVM_WDIR="$HOME/Sync/"
fi

# Check for AUTO_UPDATE Variavle and update if changes have been detected
if [[ $ENABLE_ENVM_AUTO_UPDATE == "true" ]]; then

  CHECK_REMOTE_STATUS="git status -uno" 
  HEAD_HASH="git rev-parse HEAD"

  if [[ $(CHECK_REMOTE_STATUS) != "" ]]  ; then
    cd $ENVM
    echo "Updating envm..."
    touch /tmp/envm-HEAD-$(HEAD_HASH)-$(sdate)
    git pull | 2>&1 | tee testdir
  fi

fi

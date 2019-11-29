#!/usr/bin/sh

ENVM_LOCAL="$(dirname "${BASH_SOURCE[0]}")"

# Check working dir
if $ENVM_PATH == "" ; then
  ENVM_PATH="$HOME/Sync/"
fi

# TODO: ENVM_UPDATE_EPOCH

if $ENVM_AUTO_UPDATE == 1 ; then
  if ! -e /tmp/.envm || test $(find /tmp/.envm -type f -mmin +480) ; then
    cd $ENVM_LOCAL
    echo "Updating envm..."
    git checkout master
    git pull
    touch /tmp/.envm
  fi
fi

source "$ENVM_LOCAL/scripts/functions.sh"
source "$ENVM_LOCAL/scritps/aliases.sh"

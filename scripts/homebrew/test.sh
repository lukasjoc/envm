#!/bin/sh

cat << "EOM"
test script
lukasjoc, 2019
https://lukasjoc.com
Updates Homebrew and brew caskroom
===================================================
EOM

# holds seconds of current epoch
function _curr_epoch {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

# update
function _update {
  echo "Updated in $UPDATE_BREW_DAYS day/s"
}

#Get update
epoch_target=$UPDATE_TEST_DAYS
if [[ -z "$epoch_target" ]]; then
  epoch_target=30
fi


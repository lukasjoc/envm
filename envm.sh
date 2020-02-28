#!/bin/bash

for script in $envm/scripts/*.sh; do
  source $script
done

if [ ! -v envm_wdir ]; then
  echo "wdir not set"
  export envm_wdir="$HOME/Sync/"
fi

if [ ! -d "$envm_wdir" ]; then
  echo "wdir does not exist"
fi

# Msg ------------------------------------------------
figlet "Hello, $USER"
echo "Happy Coding... :)"
# ------------------------------------------------

# update envm stuff
function update() {
  echo "Updating..."
  cd $envm
  git ch master && git pull --rebase --stat origin master
  cd $envm_wdir
  exec $SHELL -l
}


# update envm manually
function envm() {
  if [ $# == "--update" ]; then
    update
  fi
}

# automatic update looking at start_epoch.dat
if [[ $envm_auto_update_days -ge 1 ]]; then

  dat_file="$envm/cache/start_epoch.dat"
  if [ ! -f $dat_file ]; then
    date +%s  > $dat_file
  fi

  declare -i update_epoch=$(( 60 * 60 * 24 * $envm_auto_update_days + $(cat $dat_file) ))
  if [[ $(date +%s) -ge $update_epoch ]]; then
    date +%s > $dat_file
    update
  fi

fi

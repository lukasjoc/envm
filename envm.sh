#!/bin/bash

for script in $envm/scripts/*; do
	source $script
done

if [ -z ${envm_wdir+x} ]; then
  echo "could not find envm_wdir environment variable"
	echo "Please set envm_wdir variable like this echo 'export envm_wdir='~/some/dir'' >> ~/.bashrc "
fi

if [ ! -z ${envm_wdir+x} ]; then
	if [ ! -d "$envm_wdir" ]; then
  	echo "could not find working directory as requested in envm_wdir"
	fi
fi

# Message ------------------------------------------------
figlet "Hello, $USER"
fortune
# ------------------------------------------------

# automatic update looking for the value in ./cache/start_epoch.dat
if [[ $envm_auto_update_days -ge 1 ]]; then
	if [ ! -z ${envm+x} ]; then
		dat_file="$envm/cache/start_epoch.dat"
  	if [ ! -f $dat_file ]; then
   		date +%s  > $dat_file
  	fi

  	declare -i update_epoch=$(( 60 * 60 * 24 * $envm_auto_update_days + $(cat $dat_file) ))
  	if [[ $(date +%s) -ge $update_epoch ]]; then
    	date +%s > $dat_file
    	envm --update
  	fi
	else
		echo "could not find envm source directory"
	fi
fi


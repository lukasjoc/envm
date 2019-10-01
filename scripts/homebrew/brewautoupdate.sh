#!/bin/sh

cat << "EOM"
 _                                  _                        _       _
| |__  _ __ _____      ____ _ _   _| |_ ___  _   _ _ __   __| | __ _| |_ ___
| '_ \| '__/ _ \ \ /\ / / _` | | | | __/ _ \| | | | '_ \ / _` |/ _` | __/ _ \
| |_) | | |  __/\ V  V / (_| | |_| | || (_) | |_| | |_) | (_| | (_| | ||  __/
|_.__/|_|  \___| \_/\_/ \__,_|\__,_|\__\___/ \__,_| .__/ \__,_|\__,_|\__\___|

EOM

cat << "EOM"
lukasjoc, 2019
https://lukasjoc.com
===================================================
EOM


while true; do
    read -p "Do you want to create a crontab to automate this process? [yes/no] " answer
    case $answer in
        [Yy]* ) createJob; break;;
        [Nn]* ) update; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# askCrontab asks user for input
function createJob {
	options=(
		"@reboot" 
		"@yearly" 
		"@monthly" 
		"@weekly" 
		"@daily"
		"Quit"
	)

	PS3="Select update interval[1,2,3,4,5 or Quit]: "
	
	#TODO: this select is not working right now, please 
	# look into how selections work with shell scripts
	# valuw isn't taken 
	select OPT in "${options[@]}"
		do
    	case $OPT in
      	"@reboot");;
        "@yearly");;
        "@monthly");;
   			"@weekly");;
        "@daily");;
        "Quit") break;;
        * ) echo "Please answer yes or no.";;
    	esac
		done

  	
  	#TODO: Set atomicBrewer into path to be able to call 
  	#it globally from job file 
	#mv $PWD/atomicBrewer.sh /usr/local/bin/atomicBrewer

  	#TODO: Call setJob function to set the job###################
   	setJob($OPT)

	echo "Running initial update..."
	update
}

#setJon is creating a new jobs file and inserting the correct user based 
#updating schedule, executing atomic updater
#params: (OPT: schedule option)
function setJob(OPT) {
	echo "!DEBUG: Setting jobdata for $USER with $OPT"
	#sudo crontab -e #file?-> #/tmp/...
	#sudo echo "$opt atomicBrewer" >> file
} 

#update is updating the local homebrew-core repositoy
#and upgrading brew's if possible, updating and upgrading cask's 
#if possible, cleaning the hb installation if possible
function update() {
  echo "Updating and Upgrading Homebrew/Core"
	cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
	git reset --hard origin/master
	brew upgrade
	echo "Upgrading casks if any..."
	brew cask upgrade
	echo "Cleaning up..."
	brew cleanup
}

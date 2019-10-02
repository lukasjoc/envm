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
Updates Homebrew and brew caskroom
Asks you to automate the process with crontabs and sets
it up for you, if you want(and you should) :)
Gives you some scheduling options
- @yearly, @reboot. etc
===================================================
EOM

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

#setJon is creating a new jobs file and inserting the correct user based 
#updating schedule, executing atomic updater
#params: (OPT: schedule option)
# setJob(OPT) {
# 	echo "!DEBUG: Setting jobdata for $USER with $OPT"
# 	#sudo crontab -e #file?-> #/tmp/...
# 	#sudo echo "$opt atomicBrewer" >> file
# } 

# askCrontab asks user for input
function createJob {
  
	PS3="Select update interval[1,2,3,4,5 or Quit]: "
	options=(
		"@reboot" 
		"@yearly" 
		"@monthly" 
		"@weekly" 
		"@daily"
		"Quit"
	)

	select opt in "${options[@]}"
	do
			case $opt in
					"Option 1")
							echo "$opt updates";
							break;;
					"Option 2")
							echo "you chose choice 2";
							break;;
					"Option 3")
							echo "you chose choice $REPLY which is $opt";
							break;;
					"Quit") break;;
					*) echo "invalid option $REPLY";;
			esac
	done	
	#TODO: Set atomicBrewer into path to be able to call 
  #it globally from job file 
	#mv $PWD/atomicBrewer.sh /usr/local/bin/atomicBrewer

  #TODO: Call setJob function to set the job###################
  # setJob($OPT)

	echo "Running initial update..."
	update
}

while true; do
    read -p "Do you want to create a crontab to automate this process? [yes/no] " answer
    case $answer in
        [Yy]* ) createJob; break;;
        [Nn]* ) update; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

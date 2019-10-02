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
function update {
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
function setJob {
	echo "!DEBUG: Setting jobdata for $USER with $OPT"
	# TODO: create job file and create crontab rule for the user
} 

# askCrontab asks user for input
function makeAutomation {
	PS3="Select update interval[1,2,3,4,5 or 6 for Quit]: "
	options=(
		"@reboot"
		"@yearly"
		"@monthly"
		"@weekly"
		"@daily"
		"Quit"
	)

	select OPT in "${options[@]}"
	do
		case $OPT in
			"@reboot") break;;
			"@yearly") break;;
			"@monthly") break;;
			"@weekly") break;;
			"@daily") break;;
			"Quit") exit;;
			*) echo "invalid option $REPLY";;
		esac
	done

	echo "Moving brewupdate script into /usr/local/bin/" 
	if [ -f "/usr/local/bin/brewupdate" ]; then
		rm /usr/local/bin/brewupdate
	fi

	if [ -f "$PWD/brewupdate" ]; then
		cp $PWD/brewupdate /usr/local/bin/brewupdate
	else
		echo "Resyncing repository..."
		echo "git reset --hard origin/master"
		cp $PWD/brewupdate /usr/local/bin/brewupdate
	fi

	echo "Initializing jobdata..."
	setJob "$OPT";

	echo "Running initial update..."
	update
}

# TODO: maibe update this decision with a default value like this on enter [Y/n] or [n/Y]
while true; do
	read -p "Do you want to create a job to automate this process? [yes/no] " answer
	case $answer in
  	[Yy]* ) makeAutomation; break;;
    [Nn]* ) update; exit;;
    * ) echo "Please answer yes/y or no/n.";;
  esac
done

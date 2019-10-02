#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

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

#setJob is creating a new jobs file and inserting the correct user based 
#updating schedule, executing brewupdate atomic brew update script
#params: ($OPT: schedule option)
function setJob {
	# echo "Setting jobdata for $USER.."

	# #allow current user to schedule jobs
	# cronallowance=/usr/lib/cron/cron.allow
	
	# if [[ ! -f "$cronallowance" ]]; then
	# 	echo "creating cron.allow"
	# 	touch $cronallowance
	# fi
	# echo "$USER" >> $cronallowance

	# #create cron files for current user & 
	# #create the job rules
	# # cronfile=/var/spool/cron/$USER
	# cronfile=/usr/lib/cron/spool/$USER
	# if [[ ! -f "$cronfile" ]]; then
	# 	touch $cronfile
	# fi
	# echo 'MAILTO=""' >> $cronfile
	# echo "$opt brewupdate" >> $cronfile

	# echo "Validating jobbed setup..."
	# echo "Current cronjobs for $USER"
	# sudo crontab -u $USER -l
	
	# TODO: mimic the zsh update schedule and use jobspec for builtin job management

} 

# askCrontab asks user for input
function makeJob {
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
	updater=/usr/local/bin/brewupdate
	if [ -f "$updater" ]; then
		rm $updater
	fi

	if [[ ! -f "$PWD/brewupdate" ]]; then
		echo "Resyncing repository..."
		# git reset --hard origin/master
	fi 
	cp $PWD/brewupdate $updater

	echo "Initializing jobdata..."
	setJob "$OPT";

	# echo "Running initial update..."
	# update
}

# TODO: maibe update this decision with a default value like this on enter [Y/n] or [n/Y]
while true; do
	read -p "Do you want to create a cronjob to automate this process? [yes/no] " answer
	case $answer in
  	[Yy]* ) makeJob; break;;
    [Nn]* ) update; exit;;
    * ) echo "Please answer yes/y or no/n.";;
  esac
done

#!/bin/sh

cat << "EOM"
Script for homebrew updating script $PWD/brewautoupdate.sh
lukasjoc, 2019
https://lukasjoc.com
===================================================
EOM

# updatebrew is updating the local homebrew-core repositoy
# and upgrading brew's if possible
function brew() {
  echo "Updating and Upgrading Homebrew/Core"
	cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
	git reset --hard origin/master
	brew upgrade
}

# updatebrewcask is updating and upgrading cask's if possible
function cask() {
	echo "Upgrading casks if any..."
	brew cask upgrade
}

# homebrewcleanup is cleaning the homebrew installation if possible
function cleanup() {
	echo "Cleaning up..."
	brew cleanup
}

#TODO: This is not working right now, executing to infinity
brew
cask
cleanup

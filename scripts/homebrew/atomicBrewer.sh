#!/bin/sh

cat << "EOM"
Script for homebrew updating script $PWD/brewautoupdate.sh
lukasjoc, 2019
https://lukasjoc.com
===================================================
EOM

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

update

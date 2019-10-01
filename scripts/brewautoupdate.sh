#!/bin/sh

cat << "EOF"
 _                                  _                        _       _
| |__  _ __ _____      ____ _ _   _| |_ ___  _   _ _ __   __| | __ _| |_ ___
| '_ \| '__/ _ \ \ /\ / / _` | | | | __/ _ \| | | | '_ \ / _` |/ _` | __/ _ \
| |_) | | |  __/\ V  V / (_| | |_| | || (_) | |_| | |_) | (_| | (_| | ||  __/
|_.__/|_|  \___| \_/\_/ \__,_|\__,_|\__\___/ \__,_| .__/ \__,_|\__,_|\__\___|
                                                  |_|
EOF

<< EOF
lukasjoc, 2019
https://lukasjoc.com
===================================================
EOF

echo "Updating and Upgrading Homebrew/Core"
cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
git reset --hard origin/master
brew upgrade

echo "Upgrading casks if any..."
brew cask upgrade

echo "Cleaning up..."
brew cleanup

echo "Homebrew and installables up-to-date, $USER"

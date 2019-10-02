#!/bin/sh

cat << "EOM"
 _                       _       _ _
| |__  _ __ _____      _(_)_ __ (_) |_
| '_ \| '__/ _ \ \ /\ / / | '_ \| | __|
| |_) | | |  __/\ V  V /| | | | | | |_
|_.__/|_|  \___| \_/\_/ |_|_| |_|_|\__|                   
EOM

cat << "EOM"
lukasjoc, 2019
https://lukasjoc.com
Installs Homebrew and brew caskroom
Gives you some profiles of software to install
- Default Pack
- Developer Pack
===================================================
EOM

function installbrew() {
  echo "Installing Homebrew on $USER's mac"
}

installbrew

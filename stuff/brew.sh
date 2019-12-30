#!/bin/sh

if ! command -v "brew"; then
  echo "Brew not installed..."
  echo "Run /usr/bin/ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)' to install it..."
  echo "Happy brewing. :)"
fi

# Langs
echo "Installing Langs..."
brew install python # just latest python
brew install node # just latest LTS nodejs
brew install perl # just latest perl
brew install nim # just latest nimrod
brew install go # just latest golang
brew install ruby # just latest stable ruby
brew install lua # latest stable lua

# Development Tools
echo "Installing Development Tools..."
brew install git # better git
brew install git-flow-avh # git flow
brew install ack # better grep
brew install zsh # better z shell
brew install bash # better bash
brew install bats #  bash testing lib
brew install ctags # vim jump to definitions
brew install tmux # structured development
brew install tree # keep the overview
brew install watch # watch dirs
brew install wget # get the w
brew install vim # for writing code,notes...

# Other helpful stuff
echo "Installing other helpful stuff..."
brew install exercism # exercise is king
brew install figlet # funny ascii printer
brew install htop # processies screen of the gods
brew install iproute2mac # ip addr for mac
brew install kubernetes-cli # kubernetes
brew install mysql # just latest mysql

# Install Casks
echo "Installing caskrooms..."
brew cask install alfred # easy lookup
brew cask install authy # 2fa codes
brew cask install cleanmymac # clean up system
brew cask install docker # docker desktop VM
brew cask install firefox # firefox
brew cask install flux # regulate screen color based on time
brew cask install java # just latest java
brew cask install qbittorrent # open source bittorrent app
brew cask install slack # communication is king
brew cask install spectacle # window management
brew cask install spotify # music for coding
brew cask fetch eloston-chromium
brew cask install eloston-chromium # good chrome
brew cask install virtualbox # virtualization
brew cask install visual-studio-code # for reading code
brew cask install vlc # play tracks and any media
brew cask install whatsapp # talk to jerks
brew cask install xquartz # you gotta have that
brew cask install cyberduck # cool ftp/sftp client
brew cask install vagrant
brew cask install sync

# Run brew doctor after installation
brew doctor

echo "DONE"

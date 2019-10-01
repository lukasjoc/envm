#!/bin/sh

function main() {
  echo "Updating and Upgrading Homebrew/Core"
  cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
  git reset --hard origin/master
  brew upgrade

  echo "Upgrading casks if any..."
  brew cask upgrade

  echo "Cleaning up..."
  brew cleanup
}

main


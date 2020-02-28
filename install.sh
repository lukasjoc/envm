#!/bin/bash

function make_global() {
  chmod +x $1
  cp $1 $2
  mv $2 "/usr/local/bin"
}

figlet "env M anager"

# Generalise some scripts
make_global envm.sh envm
make_global update_envm.sh update_envm

#TODO:
# check $envm dir
# check for some tools (modern bash, sh, figlet)



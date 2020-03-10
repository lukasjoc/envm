#!/bin/bash

while true; do
  read -rp "Are you sure you want to say goodbye to env M anager? [N/y]" input
  case $input in 
  [yY][eE][sS]|[yY]*)
    rm -rf $envm
    rm  -rf /usr/local/bin/envm
    echo "We will miss you at env M anager ;( "
    break;;
  [nN][oO]|[nN]*)
    echo "Exiting..."
    exit;;
  *)
    echo "Exiting..."
    exit;;
  esac
done

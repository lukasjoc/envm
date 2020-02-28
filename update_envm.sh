#!/usr/bin/bash

echo "Updating env M anager..."
cd $envm
git ch master && git pull --rebase --stat origin master
cd $envm_wdir
exec $SHELL -l


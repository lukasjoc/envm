#!/bin/bash

echo "Updating env M anager..."
chmod u+x $envm/cmd.sh
cp $envm/cmd.sh $envm/envm
mv $envm/envm  "/usr/local/bin/"


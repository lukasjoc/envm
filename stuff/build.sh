#!/bin/sh

# Builds golang projects for  Mac(default) and Linux with supplied arg $1=linux
# args: $1==system, $2==binary_name
if [ $(command -v "go") ]; then
  if [ "$1" == "linux" ]; then
    echo "Building for linux amd64"
    GOOS=linux GOARCH=amd64 go build -o $2
  else
    echo "Building for darwin 386"
    GOOS=darwin GOARCH=amd64 go build -o $2
  fi
fi


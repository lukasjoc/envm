#!/bin/sh

# Builds golang projects for  Mac(default) and Linux with supplied arg $1=linux

if [ $(command -v "go") ]; then
  if [ "$1" == "linux" ]; then
    echo "Building for linux amd64"
    GOOS=linux GOARCH=amd64 go build -o {{EXECUTABLE_NAME}}
  else
    echo "Building for darwin 386"
    GOOS=darwin go build -o {{EXECUTABLE_NAME}}
  fi
fi


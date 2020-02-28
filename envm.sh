#!/bin/bash

# update envm manually
function print_help() {
  if [[ $# -le 1 || $# -gt 2 || $1 == "--help" ]]; then
    printf '%s\n\n' "Build go app for GOOS(darwin,linux) GOARCH(amd64)"
    printf '%s\n' "Usage:"
    printf '%s\n\n'  "  ./go_build.sh arg1: system(darwin/mac, linux), arg2:binary_name(some_name)"
    printf '%s\n' "Flags:"
    printf '%s\n\n' "   --help help for this bash script"
    exit 1
  fi
}

# parse args and promt accordingly
if [ $1 == "--update" ]; then
  update_envm
else
  print_help
fi


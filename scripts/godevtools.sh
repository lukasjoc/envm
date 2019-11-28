#!/bin/sh
export PATH=$PATH:$GOPATH/bin:PATH

if hash figlet 2>/dev/null; then
  figlet "godevtools"
else
cat << EOF
                 _            _              _
  __ _  ___   __| | _____   _| |_ ___   ___ | |___
 / _` |/ _ \ / _` |/ _ \ \ / / __/ _ \ / _ \| / __|
| (_| | (_) | (_| |  __/\ V /| || (_) | (_) | \__ \
 \__, |\___/ \__,_|\___| \_/  \__\___/ \___/|_|___/
 |___/
EOF
fi

cat << EOF
Author: lukasjoc, 2019 (https://lukasjoc.com)
Desc: Installs common go development tools into $GOPATH/bin
===================================================
EOF

tools() {
  declare -a tools=(
    "github.com/mdempsky/gocode"
    "github.com/uudashr/gopkgs/cmd/gopkgs"
    "github.com/ramya-rao-a/go-outline"
    "github.com/acroca/go-symbols"
    "github.com/go-delve/delve/cmd/dlv"
    "github.com/stamblerre/gocode"
    "github.com/rogpeppe/godef"

    "golang.org/x/tools/cmd/guru"
    "golang.org/x/tools/cmd/gorename"
    "golang.org/x/tools/cmd/goimports"
    "golang.org/x/lint/golint"
  )

  for tool in "${tools[@]}"
  do
    go get $tool
  done
}

echo "Installing go tools into $GOPATH"
read -p "Do you want to proceed? [y/N]" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exit 1
else
  tools
  echo "Done installing go tools into GOPATH"
fi

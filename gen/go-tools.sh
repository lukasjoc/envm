 echo "Intalling Go tools..."
 
 go get -u golang.org/x/tools/cmd/goimports &
 go get -u github.com/nsf/gocode &
 go get -u github.com/rogpeppe/godef &
 go get -u golang.org/x/lint/golint &
 go get -u github.com/kisielk/errcheck &
 
 sleep 10
 echo "Installing Sourcegraph language server"

 go get -u github.com/sourcegraph/go-langserver
 
 wait
 echo "Installed Go Tools in $GOPATH/bin"


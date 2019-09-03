#!/bin/sh
# Install pyenv with brew


# TODO:

# Install pyenv with brew? {$PYENV_PYTHON}? 
while true; do
    read -p "Install Python $PYENV_PYTHON? [Y/n] " yn
    case $yn in
        [Yy]* ) install_python break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


install_python() {
  echo "Installing Python"
# brew install pyenv 
# pyenv install {$PYENV_PYTHON} 
# export eval "$(pyenv init -)" >> ~/.zshrc
# pyenv global {$PYENV_PYTHON}
# pyenv rehash
# python --version

brew install pyenv 
&& pyenv install $PYENV_VERSION
&& export eval "$(pyenv init -)" >> ~/.zshrc 
&& pyenv global $PYENV_VERSION && pyenv rehash 
&& python --version

echo "Thank You $USER. You've installed and setup pyenv and python $PYTHON_VERSION"
echo "This process took you $SECONDS seconds" 
}

# Make file
MAC=brew
ARCH=pacman
DEB=apt

# install on mac with homebrew
mac:
	$(MAC) install figlet neofetch fortune

# install on arch with pacman
arch:
	yes | $(ARCH) pacman -S figlet neofetch fortune-mod

# install on debian and ubuntu, Pop_OS!
debian:
	$(DEB) install figlet fortune neofetch

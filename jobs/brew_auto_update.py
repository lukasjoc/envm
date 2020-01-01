import schedule as sc
import time
import os

# run brew stuff, update, upgrade, doctor and caskroom stuff
# this is to update the system regularly
def brew_auto_update():
    print("Brew auto update!! Running...")

    commands = "brew update", "brew upgrade", "brew cask upgrade", "brew cleanup", "brew doctor";
    for cmd in commands:
        os.system(cmd)

# one once per month, simplified it a bit and calculted with 30 days avg. per month. whatever
sc.every(720).hours.do(brew_auto_update)
while 1:
    sc.run_pending()
    time.sleep(1)

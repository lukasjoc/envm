
# Load and source all scripts, means functions, aliases, plugins etc
# info loads bash,sh,zsh,fish anything really with sh at the ending
for script in $ENVM/scripts/*sh; do
  source $script
done

# Checking the $ENVM_WDIR variable which contains the path to the synced working dir
if [[ $ENVM_WDIR == "" ]]; then
  export ENVM_WDIR="$HOME/Sync/"
fi

# Check for AUTO_UPDATE Variavle and update if changes have been detected
if [[ $ENABLE_ENVM_AUTO_UPDATE == "true" ]]; then
  echo "Looking for Updates in $ENVM"
  cd $ENVM
  if [[ ! $(git status -uno) ]]; then
    echo "Updating envm..."
    # touch /tmp/envm-HEAD-$(git rev-pase HEAD)-$(sdate)
    # git pull | 2>&1 | tee testdir
    echo "Processing pull.."
  fi
fi

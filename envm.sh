for script ($ENVM/scripts/*sh); do
  source $script
done

if [ ! -v ENVM_WDIR ]; then
  echo "Wdir not set"
  export ENVM_WDIR="$HOME/Sync/"
fi

if [ ! -d "$ENVM_WDIR" ]; then
  echo "Wdir does not exist"
fi

# ------------------------------------------------
echo "Hello, $USER. Happy Coding.. :)"
# ------------------------------------------------

if [[ $ENABLE_ENVM_AUTO_UPDATE == true ]]; then

  dat_file="$ENVM/cache/start_epoch.dat"
  if [ ! -f $dat_file ]; then
    date +%s  > $dat_file
  fi
  
  declare -i UPDATE_EPOCH=$(( 60 * 60 * 24 * $ENVM_AUTO_UPDATE_DAYS + $(cat $dat_file) ))
  if [[ $(date +%s) -ge $UPDATE_EPOCH ]]; then
    date +%s  > $dat_file
    echo "Updating..."
    cd $ENVM
    git ch master
    git pull
    cd $ENVM_WDIR
  fi
fi

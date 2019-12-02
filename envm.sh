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
  DAT_FILE="$ENVM/cache/start_epoch.dat"
  if [ ! -f $DAT_FILE ]; then
    touch $DAT_FILE
    printf "$(date +%s)" > $DAT_FILE
    START_EPOCH=`cat $DAT_FILE`
  else
    START_EPOCH=`cat $DAT_FILE`
  fi

  declare -i UPDATE_EPOCH=$(( 3600 * $ENVM_AUTO_UPDATE_DAYS + ${START_EPOCH} ))
  if [[ $(date +%s) -ge $UPDATE_EPOCH ]]; then
    echo "Updating..."
    cd $ENVM
    git ch master
    git pull
    cd $ENVM_WDIR
    printf "$(date +%s)" > $DAT_FILE
  fi
fi

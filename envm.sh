for script ($envm/scripts/*sh); do
  source $script
done

if [ ! -v envm_wdir ]; then
  echo "wdir not set"
  export envm_wdir="$HOME/Sync/"
fi

if [ ! -d "$envm_wdir" ]; then
  echo "wdir does not exist"
fi

# msg ------------------------------------------------
echo "Hello, $USER. Happy Coding.. :)"
# ------------------------------------------------

if [[ $envm_auto_update_days -ge 1 ]]; then

  dat_file="$envm/cache/start_epoch.dat"
  if [ ! -f $dat_file ]; then
    date +%s  > $dat_file
  fi

  declare -i update_epoch=$(( 60 * 60 * 24 * $envm_auto_update_days + $(cat $dat_file) ))
  if [[ $(date +%s) -ge $update_epoch ]]; then
    date +%s  > $dat_file
    echo "Updating..."
    cd $envm
    git ch master
    git pull
    cd $envm_wdir
    exec $SHELL -l
  fi
fi

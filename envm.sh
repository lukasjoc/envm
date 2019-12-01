# ENVM Initialization...

for script ($ENVM/scripts/*sh); do
  source $script
done

if [[ $ENVM_WDIR == "" ]]; then
  export ENVM_WDIR="$HOME/Sync/"
fi

if [[ $ENABLE_ENVM_AUTO_UPDATE == "true" ]]; then
  if [[ ! $(git status -uno) ]]; then
    echo "Updating envm..."
    CURR_DATE="$(sdate)"
    REV_HEAD="$(git rev-pase HEAD)"
    NEWDIR="/tmp/envm-HEAD-$REV_HEAD-$CURR_DATE"
    touch $NEWDIR
    echo "Processing pull... Writing logs into $NEWDIR"
    git pull | 2>&1 | tee $NEWDIR
  fi
fi

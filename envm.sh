# ENVM Initialization...

for script ($ENVM/scripts/*sh); do
  source $script
done

if [[ $ENVM_WDIR == "" ]]; then
  export ENVM_WDIR="$HOME/Sync/"
fi

if [[ ! $(git status -uno) ]]; then
  if [[ $ENABLE_ENVM_AUTO_UPDATE == "true" ]]; then
    echo "Updating envm..."
    # touch /tmp/envm-HEAD-$(git rev-pase HEAD)-$(sdate)
    # git pull | 2>&1 | tee testdir
    echo "Processing pull.."
  fi
fi

#!/bin/sh

if hash figlet 2>/dev/null; then
  figlet "launchtmux"
else
cat << EOF
 _                        _     _
| | __ _ _   _ _ __   ___| |__ | |_ _ __ ___  _   ___  __
| |/ _` | | | | '_ \ / __| '_ \| __| '_ ` _ \| | | \ \/ /
| | (_| | |_| | | | | (__| | | | |_| | | | | | |_| |>  <
|_|\__,_|\__,_|_| |_|\___|_| |_|\__|_| |_| |_|\__,_/_/\_\
EOF
fi

cat << EOF
Author: lukasjoc, 2019 (https://lukasjoc.com)
Desc: Launches a tmux working environment with 4 panes 
and attaches appropriate names
===================================================
EOF

setup() {

# TODO: open four panes with custom name
# TODO: run ssh jep in jep and mj and logs pane

	# declare -a panes=()
  # tmux new-session -d -s foo 'exec pfoo'
	# tmux send-keys 'bundle exec thin start' 'B-c'
  # tmux rename-window 'jep'
  # tmux select-window -t foo:0
  # tmux split-window -h 'exec pfoo'
  
	# tmux send-keys 'bundle exec compass watch' 'C-m'
  # tmux split-window -v -t 0 'exec pfoo'
  # tmux send-keys 'rake ts:start' 'C-m'
  # tmux split-window -v -t 1 'exec pfoo'
  # tmux -2 attach-session -t foo
  echo "TMUX environment created!"
}

echo "Launching TMUX environment..."
read -p "Do you want to proceed? [y/N]" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
else
  setup
fi
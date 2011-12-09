#!bash

action status >/dev/null && \
	tmux send -t "$SERVER_NAME" "$*" C-m


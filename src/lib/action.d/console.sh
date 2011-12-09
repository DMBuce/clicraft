#!bash

action status >/dev/null && \
	exec tmux attach -t "$SERVER_NAME"


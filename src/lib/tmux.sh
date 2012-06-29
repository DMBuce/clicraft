#!bash

multiplex_start() {
	tmux new -d -n "$SERVER_NAME" -s "$SERVER_NAME" "$START_COMMAND"
}

multiplex_cmd() {
	tmux send -t "$SERVER_NAME" "$1" C-m
}

multiplex_console() {
	exec tmux attach -t "$SERVER_NAME"
}

multiplex_status() {
	tmux has -t "$SERVER_NAME" &>/dev/null
}


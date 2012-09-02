#!bash

multiplex_start() {
	screen -d -m -S "$SERVER_NAME" -t "$SERVER_NAME" $START_COMMAND
}

multiplex_cmd() {
	screen -S "$SERVER_NAME" -p "$SERVER_NAME" -X stuff "$1
"
}

multiplex_console() {
	exec screen -d -r "$SERVER_NAME" -p "$SERVER_NAME"
}

multiplex_status() {
	screen -q -ls "$SERVER_NAME"
	test $? -gt 9
	return $?
}


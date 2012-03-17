#!bash
#
# Usage: clicraft start
#
#    Starts the minecraft server.
#

if status; then
	err "$SERVER_NAME is already running"
	return 1
fi

if [ ! -f "$SERVER_JAR" ]; then
	action dl || return $?
fi

if [ ! -w "$SERVER_DIR" ]; then
	err "No write permissions in $SERVER_DIR"
	return 1
fi

msg "Starting $SERVER_NAME"
tmux new -d -n "$SERVER_NAME" -s "$SERVER_NAME" "$START_COMMAND"
retval=$?

if [ "$?" != 0 ]; then
	return $retval
fi


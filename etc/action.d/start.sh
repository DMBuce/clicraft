#!/bin/bash

if status; then
	echo "$SERVER_NAME is already running" >&2
	return 1
fi

if [ ! -f "$SERVER_JAR" ]; then
	action init
fi

echo "Starting $SERVER_NAME"
tmux new -d -n "$SERVER_NAME" -s "$SERVER_NAME" "$START_COMMAND"
retval=$?

if [ "$?" != 0 ]; then
	return $retval
fi


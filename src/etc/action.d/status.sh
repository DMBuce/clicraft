#!bash

tmux has -t "$SERVER_NAME" &>/dev/null
retval=$?

if [ "$retval" = 0 ]; then
	echo "$SERVER_NAME is running"
	return 0
else
	echo "$SERVER_NAME is not running"
	return 1
fi


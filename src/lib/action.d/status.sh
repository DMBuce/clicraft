#!bash
#
# Usage: clicraft status
#
#    Reports on whether the minecraft server is running or not. If the server
#    is not running, returns a nonzero exit status.
#

tmux has -t "$SERVER_NAME" &>/dev/null
retval=$?

if [ "$retval" = 0 ]; then
	msg "$SERVER_NAME is running"
	return 0
else
	warn "$SERVER_NAME is not running"
	return 1
fi


#!bash
#
# Usage: clicraft restart
#
#    Restarts the minecraft server.
#

action stop
sleep 2
if ! action start; then
	retval=$?
	echo "$SERVER_NAME restart failed!" >&2
	return $retval
fi


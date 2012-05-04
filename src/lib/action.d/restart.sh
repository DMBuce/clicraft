#!bash
#
# Usage: clicraft restart
#
#    Restarts the server.
#

action stop
sleep 2
if ! action start; then
	retval=$?
	err "$SERVER_NAME restart failed!"
	return $retval
fi


#!bash
#
# Usage: clicraft status
#
#    Reports on whether the minecraft server is running or not. If the server
#    is not running, returns a nonzero exit status.
#

multiplex_status
retval=$?

if [[ "$retval" == 0 ]]; then
	msg "%s is running" "$SERVER_NAME"
	return 0
else
	warn "%s is not running" "$SERVER_NAME"
	return 1
fi


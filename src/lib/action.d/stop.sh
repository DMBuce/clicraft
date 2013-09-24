#!bash
#
# Usage: clicraft stop
#
#    Stops the server.
#

if ! status; then
	err "$SERVER_NAME is not running"
	return 1
fi

msg "Stopping $SERVER_NAME"
action cmd "$STOP_CMD"

for ((i=0; i<TIMEOUT; i++)); do
	sleep 1
	if ! status; then
		break
	fi
done


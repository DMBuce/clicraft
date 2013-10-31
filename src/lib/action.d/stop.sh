#!bash
#
# Usage: clicraft stop
#
#    Stops the server.
#

if ! status; then
	err "%s is not running" "$SERVER_NAME"
	return 1
fi

msg "Stopping %s" "$SERVER_NAME"
action cmd "$STOP_CMD"

for ((i=0; i<STOP_TIMEOUT; i++)); do
	sleep 1
	if ! status; then
		break
	fi
done


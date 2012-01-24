#!bash
#
# Usage: clicraft stop
#
#    Stops the minecraft server.
#

if ! status; then
	err "$SERVER_NAME is not running"
	return 1
fi

msg "Stopping $SERVER_NAME"
action cmd "stop"

for i in {1..20}; do
	sleep 1
	if ! status; then
		break
	fi
done


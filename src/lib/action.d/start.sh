#!bash
#
# Usage: clicraft start
#
#    Starts the server.
#

if status; then
	err "%s is already running" "$SERVER_NAME"
	return 1
fi

if [[ ! -f "$SERVER_JAR" ]]; then
	action dl || return $?
fi

if [[ ! -w "$SERVER_DIR" ]]; then
	err "No write permissions in %s" "$SERVER_DIR"
	return 1
fi

msg "Starting %s" "$SERVER_NAME"

TIMEOUT=$START_TIMEOUT serverlog "$RE_START" multiplex_start >/dev/null

if ! status; then
	err "%s failed to start" "$SERVER_NAME"
	return 1
else
	return 0
fi


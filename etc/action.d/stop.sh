#!/bin/bash

if ! status; then
	echo "$SERVER_NAME is not running" >&2
	return 1
fi

echo "Stopping $SERVER_NAME"
action cmd "stop"

for i in {1..20}; do
	sleep 1
	if ! status; then
		break
	fi
done


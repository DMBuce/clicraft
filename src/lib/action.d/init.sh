#!bash

if [ -f "$SERVER_JAR" ]; then
	echo "$SERVER_JAR already exists" >&2
	return 1
fi

echo "Downloading $(basename $SERVER_JAR)"
$DOWNLOAD_COMMAND


#!bash
#
# Usage: clicraft init
#
#    Does the prepwork needed for running a server. Currently, this only
#    consists of downloading the jar file.
#

if [ -f "$SERVER_JAR" ]; then
	echo "$SERVER_JAR already exists" >&2
	return 1
fi

echo "Downloading $(basename $SERVER_JAR)"
$DOWNLOAD_COMMAND


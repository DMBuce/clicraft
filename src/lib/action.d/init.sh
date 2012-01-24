#!bash
#
# Usage: clicraft init
#
#    Does the prepwork needed for running a server. Currently, this only
#    consists of downloading the jar file.
#

if [ -f "$SERVER_JAR" ]; then
	err "$SERVER_JAR already exists"
	return 1
fi

msg "Downloading $(basename $SERVER_JAR)"
$DOWNLOAD_COMMAND


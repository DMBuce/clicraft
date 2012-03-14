#!bash
#
# Usage: clicraft dl
#
#    Downloads the server jar file.
#

if [ -f "$SERVER_JAR" ]; then
	msg "Backing up server jar to $(basename $SERVER_JAR).ccback"
	mv "$SERVER_JAR" "$SERVER_JAR.ccback" || return $?

	msg "Downloading new $(basename $SERVER_JAR)"
else
	msg "Downloading $(basename $SERVER_JAR)"
fi

$DOWNLOAD_COMMAND

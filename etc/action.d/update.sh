#!/bin/bash

if [ -f "$SERVER_JAR" ]; then
	echo "Backing up server jar to $(basename $SERVER_JAR).ccback"
	mv "$SERVER_JAR" "$SERVER_JAR.ccback" || return $?
fi

echo "Downloading new $(basename $SERVER_JAR)"
download

action restart


#!bash
#
# Usage: clicraft dl [version]
#
#    Downloads version <version> of the server jar file. If <version> is
#    "release" or "snapshot", the latest release or snapshot version is used.
#

SERVER_VERSION="${1-$SERVER_VERSION}"

# dump versions.json to stdout
versions_json() {
	local version_url='http://s3.amazonaws.com/Minecraft.Download/versions/versions.json'
	if which curl &>/dev/null; then
		curl -sL "$version_url"
	elif which wget &>/dev/null; then
		wget -q -O- "$version_url"
	else
		err "Can't find %s or %s, unable to download %s" "curl" "wget" "versions.json"
		return 1
	fi
}

JAR_DIR="$(dirname "$SERVER_JAR")"
if [[ ! -w "$JAR_DIR" ]]; then
	err "No write permissions in %s" "$JAR_DIR"
	return 1
fi

# substitute version
if grep -q '%v' <<<"$DOWNLOAD_COMMAND"; then
	VERSION="$SERVER_VERSION"
	if [[ "$SERVER_VERSION" == 'snapshot' || "$SERVER_VERSION" == 'release' ]]; then
		VERSION="$(versions_json | awk -F\" "/\"$SERVER_VERSION\":/ {print \$4}")"
		if [[ "$VERSION" == "" ]]; then
			err "Can't determine latest %s version." "$SERVER_VERSION"
			return 1
		fi

		msg "Latest %s version is %s" "$SERVER_VERSION" "$VERSION"
	fi
	DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND//'%v'/$VERSION}"
fi

# back up server jar
if [[ -f "$SERVER_JAR" ]]; then
	msg "Backing up server jar to %s" "$(basename $SERVER_JAR).ccback"
	mv "$SERVER_JAR" "$SERVER_JAR.ccback" || return $?

	msg "Downloading new %s" "$(basename $SERVER_JAR)"
else
	msg "Downloading %s" "$(basename $SERVER_JAR)"
fi

$DOWNLOAD_COMMAND

# restore server jar if download failed
if [[ ! -f "$SERVER_JAR" ]]; then
	msg "No %s after running \`%s\'" "$(basename $SERVER_JAR)" "$DOWNLOAD_COMMAND"
	msg "Restoring server jar from %s" "$(basename $SERVER_JAR).ccback"
	mv "$SERVER_JAR.ccback" "$SERVER_JAR"
fi


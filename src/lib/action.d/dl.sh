#!bash
#
# Usage: clicraft dl [version]
#
#    Downloads the server jar file.
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
		err "Can't find curl or wget, unable to download versions.json"
		return 1
	fi
}

JAR_DIR="$(dirname "$SERVER_JAR")"
if [[ ! -w "$JAR_DIR" ]]; then
	err "No write permissions in $JAR_DIR"
	return 1
fi

# substitute version
if grep -q '%v' <<<"$DOWNLOAD_COMMAND"; then
	VERSION="$SERVER_VERSION"
	if [[ "$SERVER_VERSION" == 'snapshot' || "$SERVER_VERSION" == 'release' ]]; then
		VERSION="$(versions_json | awk -F\" "/\"$SERVER_VERSION\":/ {print \$4}")"
		if [[ "$VERSION" == "" ]]; then
			err "Can't determine latest $SERVER_VERSION version."
			return 1
		fi

		msg "Latest $SERVER_VERSION version is $VERSION"
	fi
	DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND//'%v'/$VERSION}"
fi

# back up server jar
if [[ -f "$SERVER_JAR" ]]; then
	msg "Backing up server jar to $(basename $SERVER_JAR).ccback"
	mv "$SERVER_JAR" "$SERVER_JAR.ccback" || return $?

	msg "Downloading new $(basename $SERVER_JAR)"
else
	msg "Downloading $(basename $SERVER_JAR)"
fi

$DOWNLOAD_COMMAND


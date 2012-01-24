# this file is in the public domain

_clicraft() {
	local BIN CLICRAFT ETC LIB
	BIN="$(dirname $(readlink -f $(which clicraft)))"
	CLICRAFT="${CLICRAFT-$(dirname $BIN)}"
	ETC="$CLICRAFT/etc"
	LIB="$CLICRAFT/lib"

	local SERVER_DIR SERVER_NAME SERVER_JAR SERVER_URL START_COMMAND DOWNLOAD_COMMAND
	. "$LIB/defaults.sh"
	. "$LIB/functions.sh"
	
	if [ -f "$CLICRAFT/etc/clicraft.conf" ]; then
	    . "$CLICRAFT/etc/clicraft.conf"
	fi

	local cur prev
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	if [ "$COMP_CWORD" = 1 ]; then
		COMPREPLY=( $(compgen -W "$(actions)" -- $cur) )
	fi
}

complete -F _clicraft clicraft


# this file is in the public domain

_clicraft_cmd() {
	local mc_cmds
	mc_cmds="ban ban-ip banlist deop gamemode give help ? kick kill list me
		op pardon pardon-ip save-all save-off save-on say stop tell time
		toggledownfall tp whitelist xp"
	if [ "$COMP_CWORD" = 2 ]; then
		echo $mc_cmds
	fi
}

_clicraft_help() {
	if [ "$COMP_CWORD" = 2 ]; then
		actions
	fi
}

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
	action="${COMP_WORDS[1]}"

	if [ "$COMP_CWORD" = 1 ]; then
		COMPREPLY=( $(compgen -W "$(actions)" -- $cur) )
	elif declare -f _clicraft_$action >/dev/null; then
		COMPREPLY=( $(compgen -W "$(_clicraft_$action)" -- $cur) )
	fi
}

complete -F _clicraft clicraft


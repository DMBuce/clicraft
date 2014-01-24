#!bash

# Prints an info message to stdout
msg() {
	local mesg=$1
	shift

	printf -- "${mesg}\n" "$@"
}

# Prints a warning to stderr
warn() {
	local mesg=$1
	shift

	printf -- "${mesg}\n" "$@" >&2
}

# Prints an error to stderr
err() {
	local mesg=$1
	shift

	printf -- "${mesg}\n" "$@" >&2
}

# Finds the location of a system action script
sys_actionfile() {
	local ACTION="$1"

	if [[ -f "$EXECDIR/action.d/$ACTION.sh" ]]; then
		echo "$EXECDIR/action.d/$ACTION.sh"
	else
		warn "Unknown action: %s" "$ACTION"
		return 1
	fi
}

# Finds the location of a local action script
local_actionfile() {
	local ACTION="$1"

	if [[ -f "$CONFDIR/action.d/$ACTION.sh" ]]; then
		echo "$CONFDIR/action.d/$ACTION.sh"
	else
		warn "Unknown action: %s" "$ACTION"
		return 1
	fi
}

# Finds the location of an action script
actionfile() {
	local ACTION="$1"

	# try to find action script
	if ! local_actionfile "$ACTION" 2>/dev/null && \
	   ! sys_actionfile "$ACTION"; then
		return 1
	fi
}

# Executes a system action script
sys_action() {
	local ACTION="$1"
	shift

	local FILE="$(sys_actionfile "$ACTION")"
	if [[ "$FILE" != "" ]]; then
		. "$FILE" "$@"
	else
		return 1
	fi
}

# Executes a local action script
local_action() {
	local ACTION="$1"
	shift

	local FILE="$(local_actionfile "$ACTION")"
	if [[ "$FILE" != "" ]]; then
		. "$FILE" "$@"
	else
		return 1
	fi
}

# Executes an action script
action() {
	local ACTION="$1"
	shift

	local FILE="$(actionfile "$ACTION")"
	if [[ "$FILE" != "" ]]; then
		. "$FILE" "$@"
	else
		action help
	fi
}

# Returns a list of available actions
actions() {
	find "$CONFDIR/action.d" "$EXECDIR/action.d" \
		-maxdepth 1 ! -type d -name \*.sh | \
		sed 's|^.*/||; s|\.sh$||' | sort -u
}

# Returns 0 if the server is running, 1 otherwise
status() {
	multiplex_status
}

# Sends command to server
cmd() {
	multiplex_cmd "$*"
}

# Prints the usage of an action script
usage() {
	local FILE USAGELINE PRINTUSAGE line
	USAGELINE="# Usage: clicraft $1"
	if ! FILE="$(actionfile "$1")"; then
		action help
		return 1
	fi

	while read line; do
		if [[ "$line" == $USAGELINE* ]]; then
			PRINTUSAGE=TRUE
		fi

		if [[ "$PRINTUSAGE" == 'TRUE' ]]; then
			[[ "$line" != '#'* ]] && break
			line="${line#'#'}"
			msg "${line#' '}"
		fi
	done <"$FILE"
}

# Look up a regex in the db
redb_lookup() {
	local KEY PREFIX KEYVAL VALUE
	KEY="$1"
	PREFIX="$2"
	KEYVAL="$(grep "^$KEY " "$REDB")"
	VALUE="${KEYVAL#$KEY }"

	if [[ "$VALUE" == "" ]]; then
		warn "Key not found in database: %s" "$KEY"
		return 1
	fi

	# if given a prefix, prepend it to the regex after start-of-line
	if [[ "$PREFIX" != "" && "$VALUE" == '^^'* ]]; then
		VALUE="^${PREFIX}${VALUE#'^^'}"
	fi

	echo "$VALUE"
}

# Insert a regex into the db
redb_insert() {
	local KEY NEWVALUE VALUE
	KEY="$1"
	shift
	NEWVALUE="$*"
	VALUE="$(redb_lookup "$KEY" 2>/dev/null)"

	if [[ "$VALUE" != "" ]]; then
		warn "Key already in database: %s" "$KEY"
		return 1
	fi

	echo "$KEY $NEWVALUE" >>"$REDB"
}

# Update a regex in the db
redb_update() {
	local KEY NEWVALUE VALUE
	KEY="$1"
	shift
	NEWVALUE="$*"
	VALUE="$(redb_lookup "$KEY")" || return $?

	KEY="${KEY//\//\\/}"
	NEWVALUE="${NEWVALUE//\//\\/}"
	sed -i "/^$KEY / s/ .*/ $NEWVALUE/" "$REDB"
}

# Remove a regex from the db
redb_delete() {
	local KEY VALUE
	KEY="$1"
	VALUE="$(redb_lookup "$KEY")" || return $?

	KEY="${KEY//\//\\/}"
	NEWVALUE="${NEWVALUE//\//\\/}"
	sed -i "/^$KEY / d" "$REDB"
}

# Safely runs /save-off on the server
save-off() {
	mklock save || return $?
	serverlog "$RE_SAVE_OFF" cmd 'save-off' >/dev/null
	local retval=$?
	rmlock save
	return $retval
}

# Safely runs /save-on on the server
save-on() {
	mklock save || return $?
	serverlog "$RE_SAVE_ON" cmd 'save-on' >/dev/null
	local retval=$?
	rmlock save
	return $retval
}

# Safely runs /save-all on the server
save-all() {
	mklock save || return $?
	serverlog "$RE_SAVE_ALL" cmd 'save-all' >/dev/null
	local retval=$?
	rmlock save
	return $retval
}

# Prints the list of connected players to stdout
list() {
	serverlog "$RE_LIST" cmd "list" | \
		sed -nr "2,$ {
			s/$RE_LIST/\1/
			p
		}"
}

# Kicks a player from the server
kick() {
	local OUTPUT PLAYER
	PLAYER="$1"

	OUTPUT="$(serverlog "$RE_KICK" cmd "kick $PLAYER")"
	[[ "$OUTPUT" =~ $RE_KICK_SUCCESS ]]
}

# Bans a player or ip from the server
ban() {
	local PLAYER CMD RE_PATTERN
	PLAYER="$1"

	if [[ "$PLAYER" =~ $RE_IPADDR ]]; then
		CMD='ban-ip'
	else
		CMD='ban'
	fi

	RE_PATTERN="$(str2val RE_$CMD upper)"

	serverlog "$RE_PATTERN" cmd "$CMD $PLAYER" >/dev/null
}

# Pardons a banned player or ip
pardon() {
	local PLAYER RE_PATTERN CMD BANLIST NUMBANS
	PLAYER="$1"

	if [[ "$PLAYER" =~ $RE_IPADDR ]]; then
		CMD='pardon-ip'
		BANLIST="$SERVER_DIR/banned-ips.txt"
	else
		CMD='pardon'
		BANLIST="$SERVER_DIR/banned-players.txt"
	fi

	RE_PATTERN="$(str2val RE_$CMD upper)"
	NUMBANS="$(wc -w <"$BANLIST")"

	serverlog "$RE_PATTERN" cmd "$CMD $PLAYER" >/dev/null
	test "$(wc -w <"$BANLIST")" -lt "$NUMBANS"
}

# Converts a string to something useable as a variable name
str2var() {
	local str
	case "$2" in
	  'upper') str="${1^^}" ;;
	  'lower') str="${1,,}" ;;
	  *)       str="$1" ;;
	esac

	echo "${str//[^a-zA-Z0-9_]/_}"
}

# Prints the value of the variable corresponding to a string
str2val() {
	local var="$(str2var "$@")"
	echo "${!var}"
}

# Prints the directory corresponding to a dimension
dimdir() {
	local dim world
	dim="$1"
	world="$(serverprop level-name)" || return 1

	if [[ "$dim" == overworld ]]; then
		echo "$SERVER_DIR/$world"
	elif [[ "$dim" == nether && "$SERVER_TYPE" == minecraft ]]; then
		echo "$SERVER_DIR/$world/DIM-1"
	elif [[ "$dim" == nether ]]; then
		echo "$SERVER_DIR/$world"_nether
	elif [[ "$dim" == end && "$SERVER_TYPE" == minecraft ]]; then
		echo "$SERVER_DIR/$world/DIM1"
	elif [[ "$dim" == end ]]; then
		echo "$SERVER_DIR/$world"_the_end
	else
		echo "$SERVER_DIR/${world}_${dim}"
	fi
}

# Prints a value defined in server.properties
serverprop() {
	local PROP="$1"
	local NAMEVAL="$(grep "^$PROP=" "$SERVER_DIR/server.properties")"
	local VALUE="${NAMEVAL#$PROP=}"

	if [[ "$VALUE" == "" ]]; then
		warn "Property \`%s' not defined in %s" "$PROP" "$SERVER_DIR/server.properties"
		return 1
	fi

	echo "$VALUE"
}

# Searches for programs in PATH, HOME/bin and SERVER_DIR
wickedwhich() {
	local dir exe PATHORIG
	PATHORIG="$PATH"

	for dir in "$HOME/bin" "$SERVER_DIR"; do
		PATH="$PATH:$dir"
	done

	for exe in "$@"; do
		if command -v "$exe"; then
			PATH="$PATHORIG"
			return 0
		fi
	done

	warn "Could not find %s in %s" "$1" "$PATH"
	PATH="$PATHORIG"
	return 1
}

# Run every command in the exit trap stack
exithandler() {
	local i
	for ((i=${#TRAPSTACK[@]}-1; i>=0; i--)); do
		eval "${TRAPSTACK[i]}"
	done
}
TRAPSTACK=()

# Push command onto exit trap stack
pushtrap() {
	TRAPSTACK=("${TRAPSTACK[@]}" "$1")
}

# Pop last command from exit trap stack
poptrap() {
	if [[ "${TRAPSTACK[${#TRAPSTACK[@]}-1]}" != "$1" ]]; then
		warn "Attempt to remove last exit trap failed: %s" "$1"
		return 1
	fi
	unset TRAPSTACK[${#TRAPSTACK[@]}-1]
}

# Create a lock
mklock() {
	TMPDIR="${TMPDIR-/tmp}"
	local lockdir="$TMPDIR/clicraft.$EUID"
	local lockfile="$lockdir/$1.lock"
	mkdir -p -m 0700 "$(dirname "$lockfile")"
	if [[ "$(stat -Lc "%a %u" "$lockdir")" != "700 $EUID" ]]; then
		warn "Lock directory %s does not have user/mode %s/%d" "$lockdir" "$(id -un)" "700"
		return 1
	fi

	if (set -o noclobber && echo $$>"$lockfile") 2>/dev/null; then
		pushtrap "rm -f '$lockfile'"
		return 0
	fi

	warn "Lock %s held by pid %s" "$lockfile" "$(<"$lockfile")"
	return 1
}

# Remove a lock
rmlock() {
	TMPDIR="${TMPDIR-/tmp}"
	local lockdir="$TMPDIR/clicraft.$EUID"
	local lockfile="$lockdir/$1.lock"
	mkdir -p -m 0700 "$(dirname "$lockfile")"
	if [[ "$(stat -Lc "%a %u" "$lockdir")" != "700 $EUID" ]]; then
		warn "Lock directory %s does not have user/mode %s/%d" "$lockdir" "$(id -un)" "700"
		return 1
	fi

	if [[ ! -f "$lockfile" ]]; then
		warn "Lock %s not found" "$lockfile"
	elif [[ "$(<"$lockfile")" != $$ ]]; then
		warn "Lock %s held by pid %s" "$lockfile" "$(<"$lockfile")"
		return 1
	fi

	rm "$lockfile" 2>/dev/null
	retval=$?
	poptrap "rm -f '$lockfile'" &>/dev/null

	return $retval
}


# Dear Drunk Me,
#
#     Please don't touch any of the code below. You'll likely just make the
#     situation worse for both of us.
#
# Sincerely,
# -Sober Me
#


# Prints server log, runs a command, and waits until it's safe to continue
serverlog() {
	local TIMERPID TAILPID CONDITION retval

	CONDITION="$1"
	shift

	if [[ $# == 0 ]]; then
		warn "Usage: serverlog <condition> <command>"
	fi

	# launch a process in the background that will time out eventually
	sleep "$TIMEOUT" &
	TIMERPID="$!"

	# kill timeout process if we exit abnormally
	pushtrap "kill '$TIMERPID' 2>/dev/null"

	# if CONDITION is an integer
	if [[ "$CONDITION" =~ ^[+]?[0-9]+$ ]]; then
		# print server log to stdout and quit after CONDITION lines
		tail -Fn0 --pid "$TIMERPID" "$SERVER_LOG" 2>/dev/null | {
			head -n "$CONDITION"
			kill "$TIMERPID" 2>/dev/null
		} &
	else

		# print server log to stdout
		tail -Fn0 --pid "$TIMERPID" "$SERVER_LOG" 2>/dev/null &
		TAILPID="$!"
		pushtrap "kill '$TAILPID' 2>/dev/null"

		# kill timeout process when we see CONDITION in server log
		tail -Fn0 --pid "$TIMERPID" "$SERVER_LOG" 2>/dev/null | {
			egrep -ql "$CONDITION"
			kill "$TAILPID" "$TIMERPID" 2>/dev/null
		} &
	fi

	# run command
	"$@"

	# wait until the backgrounded timeout process exits
	{
		wait "$TAILPID" "$TIMERPID"
	} &>/dev/null
	retval=$?

	# clear the traps we set earlier
	poptrap "kill '$TAILPID' 2>/dev/null" 2>/dev/null
	poptrap "kill '$TIMERPID' 2>/dev/null"

	# return inverted return value of wait
	test $retval != 0

}


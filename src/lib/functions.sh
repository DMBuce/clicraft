#!bash

# Prints an info message to stdout
msg() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@"
}

# Prints a warning to stderr
warn() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@" >&2
}

# Prints an error to stderr
err() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@" >&2
}

# Finds the location of a system action script
sys_actionfile() {
	local ACTION="$1"

	if [[ -f "$EXECDIR/action.d/$ACTION.sh" ]]; then
		echo "$EXECDIR/action.d/$ACTION.sh"
	else
		warn "Unknown action: $ACTION"
		return 1
	fi
}

# Finds the location of a local action script
local_actionfile() {
	local ACTION="$1"

	if [[ -f "$CONFDIR/action.d/$ACTION.sh" ]]; then
		echo "$CONFDIR/action.d/$ACTION.sh"
	else
		warn "Unknown action: $ACTION"
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
		-maxdepth 1 -type f -name \*.sh | \
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
	FILE="$(actionfile "$1")"
	if [[ $? != 0 ]]; then
		action help
		return 1
	fi

	while read line; do
		if [[ "${line#$USAGELINE}" != "$line" ]]; then
			PRINTUSAGE=TRUE
		fi

		if [[ "$PRINTUSAGE" = 'TRUE' ]]; then
			[ "${line#'#'}" = "$line" ] && break
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
	KEYVAL="$(grep "^$KEY " "$DB")"
	VALUE="${KEYVAL#$KEY }"

	if [[ "$VALUE" = "" ]]; then
		warn "Key not found in database: $KEY"
		return 1
	fi

	# if given a prefix, prepend it to the regex after start-of-line
	if [[ "$PREFIX" != "" && "${VALUE:0:2}" = '^^' ]]; then
		VALUE="^${PREFIX}${VALUE:2}"
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
		warn "Key already in database: $KEY"
		return 1
	fi

	echo "$KEY $NEWVALUE" >>"$DB"
}

# Update a regex in the db
redb_update() {
	local KEY NEWVALUE VALUE
	KEY="$1"
	shift
	NEWVALUE="$*"
	VALUE="$(redb_lookup "$KEY")"
	retval=$?

	if [[ "$retval" != 0 ]]; then
		return $retval
	fi

	KEY="${KEY//\//\\/}"
	NEWVALUE="${NEWVALUE//\//\\/}"
	sed -i "/^$KEY / s/ .*/ $NEWVALUE/" "$DB"
}

# Remove a regex from the db
redb_delete() {
	local KEY VALUE
	KEY="$1"
	VALUE="$(redb_lookup "$KEY")"
	retval=$?

	if [[ "$retval" != 0 ]]; then
		return $retval
	fi

	KEY="${KEY//\//\\/}"
	NEWVALUE="${NEWVALUE//\//\\/}"
	sed -i "/^$KEY / d" "$DB"
}

# Safely runs /save-off on the server
save-off() {
	local RE_SAVE_OFF="$(redb_lookup cmd/save-off "$(redb_lookup timestamp)")"
	mklock save || return $?
	serverlog "$RE_SAVE_OFF" cmd 'save-off' >/dev/null
	local retval=$?
	rmlock save
	return $retval
}

# Safely runs /save-on on the server
save-on() {
	local RE_SAVE_ON="$(redb_lookup cmd/save-on "$(redb_lookup timestamp)")"
	mklock save || return $?
	serverlog "$RE_SAVE_ON" cmd 'save-on' >/dev/null
	local retval=$?
	rmlock save
	return $retval
}

# Safely runs /save-all on the server
save-all() {
	local RE_SAVE_ALL="$(redb_lookup cmd/save-all "$(redb_lookup timestamp)")"
	mklock save || return $?
	serverlog "$RE_SAVE_ALL" cmd 'save-all' >/dev/null
	local retval=$?
	rmlock save
	return $retval
}

# Prints the list of connected players to stdout
list() {
	local RE_TIMESTAMP RE_PATTERN
	RE_TIMESTAMP="$(redb_lookup timestamp)"
	RE_PATTERN="$(redb_lookup "cmd/list" "$RE_TIMESTAMP")"

	serverlog "$RE_PATTERN" cmd "list" | \
		sed -nr "2,$ {
			s/$RE_PATTERN/\1/
			p
		}"
}

# Kicks a player from the server
kick() {
	local RE_TIMESTAMP RE_PATTERN OUTPUT PLAYER
	PLAYER="$1"
	RE_TIMESTAMP="$(redb_lookup timestamp)"
	RE_PATTERN="$(redb_lookup "cmd/kick" "$RE_TIMESTAMP")"
	RE_SUCCESS="$(redb_lookup "cmd/kick/success" "$RE_TIMESTAMP")"

	OUTPUT="$(serverlog "$RE_PATTERN" cmd "kick $PLAYER")"
	egrep -q "$RE_SUCCESS" <<<"$OUTPUT"
}

# Bans a player or ip from the server
ban() {
	local PLAYER RE_TIMESTAMP RE_PATTERN RE_IP CMD
	PLAYER="$1"
	RE_IP="$(redb_lookup ip-address)"

	if egrep -q "$RE_IP" <<<"$PLAYER"; then
		CMD='ban-ip'
	else
		CMD='ban'
	fi

	RE_TIMESTAMP="$(redb_lookup timestamp)"
	RE_PATTERN="$(redb_lookup "cmd/$CMD" "$RE_TIMESTAMP")"

	serverlog "$RE_PATTERN" cmd "$CMD $PLAYER" >/dev/null
}

# Pardons a banned player or ip
pardon() {
	local PLAYER RE_TIMESTAMP RE_PATTERN RE_IP CMD BANLIST NUMBANS
	PLAYER="$1"
	RE_IP="$(redb_lookup ip-address)"

	if egrep -q "$RE_IP" <<<"$PLAYER"; then
		CMD='pardon-ip'
		BANLIST="$SERVER_DIR/banned-ips.txt"
	else
		CMD='pardon'
		BANLIST="$SERVER_DIR/banned-players.txt"
	fi

	RE_TIMESTAMP="$(redb_lookup timestamp)"
	RE_PATTERN="$(redb_lookup "cmd/$CMD" "$RE_TIMESTAMP")"
	NUMBANS="$(wc -w "$BANLIST" | cut -d ' ' -f 1)"

	serverlog "$RE_PATTERN" cmd "$CMD $PLAYER" >/dev/null
	test "$(wc -w "$BANLIST" | cut -d ' ' -f 1)" -lt "$NUMBANS"
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

	if [[ "$VALUE" = "" ]]; then
		warn "Property \`$PROP' not defined in $SERVER_DIR/server.properties"
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
		if which "$exe" 2>/dev/null; then
			PATH="$PATHORIG"
			return 0
		fi
	done

	warn "Could not find $1 in $PATH"
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
		warn "Attempt to remove last exit trap failed: $1"
		return 1
	fi
	unset TRAPSTACK[${#TRAPSTACK[@]}-1]
}

# Create a lock
mklock()
{
	TMPDIR="${TMPDIR-/tmp}"
	local USER="$(whoami)"
	local lockdir="$TMPDIR/clicraft.$USER"
	local lockfile="$lockdir/$1.lock"
	mkdir -p -m 0700 "$(dirname "$lockfile")"
	if [[ "$(stat -Lc "%a %U" "$lockdir")" != "700 $USER" ]]; then
		warn "Lock directory $lockdir does not have user/mode $USER/700"
		return 1
	fi

	if (set -o noclobber && echo $$>"$lockfile") 2>/dev/null; then
		pushtrap "rm -f '$lockfile'"
		return 0
	fi

	warn "Lock $lockfile held by pid $(<"$lockfile")"
	return 1
}

# Remove a lock
rmlock() {
	TMPDIR="${TMPDIR-/tmp}"
	local USER="$(whoami)"
	local lockdir="$TMPDIR/clicraft.$USER"
	local lockfile="$lockdir/$1.lock"
	mkdir -p -m 0700 "$(dirname "$lockfile")"
	if [[ "$(stat -Lc "%a %U" "$lockdir")" != "700 $USER" ]]; then
		warn "Lock directory $lockdir does not have user/mode $USER/700"
		return 1
	fi

	if [[ ! -f "$lockfile" ]]; then
		warn "Lock $lockfile not found"
	elif [[ "$(<"$lockfile")" != $$ ]]; then
		warn "Lock $lockfile held by pid $(<"$lockfile")"
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

	if [[ $# = 0 ]]; then
		warn "Usage: serverlog <condition> <command>"
	fi

	# launch a process in the background that will time out eventually
	sleep "$TIMEOUT" &
	TIMERPID="$!"

	# kill timeout process if we exit abnormally
	pushtrap "kill '$TIMERPID' 2>/dev/null"

	# if CONDITION is an integer
	if [[ "$CONDITION" -eq "$CONDITION" ]] 2>/dev/null; then
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


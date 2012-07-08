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

	if [ -f "$EXECDIR/action.d/$ACTION.sh" ]; then
		echo "$EXECDIR/action.d/$ACTION.sh"
	else
		warn "Unknown action: $ACTION"
		return 1
	fi
}

# Finds the location of a local action script
local_actionfile() {
	local ACTION="$1"

	if [ -f "$CONFDIR/action.d/$ACTION.sh" ]; then
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
	if [ "$FILE" != "" ]; then
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
	if [ "$FILE" != "" ]; then
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
	if [ "$FILE" != "" ]; then
		. "$FILE" "$@"
	else
		action help
	fi
}

# Returns a list of available actions
actions() {
	local FILE
	for FILE in \
	  $(ls $CONFDIR/action.d/*.sh $EXECDIR/action.d/*.sh 2>/dev/null)
	do
		basename ${FILE%.sh}
	done | sort -u
}

# Returns 0 if the server is running, 1 otherwise
status() {
	multiplex_status
}

# Prints the usage of an action script
usage() {
	local FILE="$1"
	local USAGELINE='# Usage: '
	local line

	while read line; do
		if [ "${line#$USAGELINE}" != "$line" ]; then
			local PRINTUSAGE=TRUE
		fi

		if [ "$PRINTUSAGE" = 'TRUE' ]; then
			[ "${line#'#'}" = "$line" ] && break
			line="${line#'#'}"
			msg "${line#' '}"
		fi
	done <"$FILE"
}

# Prints a value defined in server.properties
serverprop() {
	local PROP="$1"
	local NAMEVAL="$(grep "^$PROP=" "$SERVER_DIR/server.properties")"
	local VALUE="${NAMEVAL#*=}"

	if [ "$VALUE" = "" ]; then
		warn "Property \`$PROP' not defined in $SERVER_DIR/server.properties"
		return 1
	fi

	echo "$VALUE"
}


# Dear Drunk Me,
#
#     Please don't touch any of the code below. You'll likely just make the
#     situation worse for both of us.
#
# Sincerely,
# -Sober Me
#


# Prints server.log, runs a command, and waits until it's safe to continue
serverlog() {
	local TIMERPID CONDITION retval

	CONDITION="$1"
	shift

	if [ $# = 0 ]; then
		warn "Usage: serverlog <condition> <command>"
	fi

	# make sure server.log exists, we're gonna need it
	if [ ! -f "$SERVER_DIR/server.log" ]; then
		touch "$SERVER_DIR/server.log"
	fi

	# launch a process in the background that will time out eventually
	sleep "$TIMEOUT" &
	TIMERPID="$!"

	# if CONDITION is an integer
	if [ "$CONDITION" -eq "$CONDITION" ] 2>/dev/null; then
		# print server.log to stdout and quit after CONDITION lines
		tail -fn0 --pid "$TIMERPID" "$SERVER_DIR/server.log" | {
			head -n "$CONDITION"
			retval=0
			kill "$TIMERPID" 2>/dev/null
		} &
	else

		# print server.log to stdout
		tail -fn0 --pid "$TIMERPID" "$SERVER_DIR/server.log" &

		# kill timeout process when we see CONDITION in server.log
		tail -fn0 --pid "$TIMERPID" "$SERVER_DIR/server.log" | {
			egrep -ql "$CONDITION"
			retval=$?
			kill "$TIMERPID" 2>/dev/null
		} &
	fi

	# run command
	"$@"

	# wait until the backgrounded timeout process exits
	{
		wait "$TIMERPID"
	} &>/dev/null

	return $retval
}


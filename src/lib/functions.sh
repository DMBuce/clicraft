#!bash

msg() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@"
}

warn() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@" >&2
}

err() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@" >&2
}

actionfile() {
	local ACTION="$1"

	if [ -f "$ETC/action.d/$ACTION.sh" ]; then
		echo "$ETC/action.d/$ACTION.sh"
	elif [ -f "$LIB/action.d/$ACTION.sh" ]; then
		echo "$LIB/action.d/$ACTION.sh"
	else
		warn "Unknown action: $ACTION"
		return 1
	fi
}

action() {
	local ACTION="$1"
	shift

	local FILE=$(actionfile "$ACTION")
	if [ "$FILE" != "" ]; then
		. "$FILE" "$@"
	else
		action help
	fi
}

actions() {
	local FILE
	for FILE in \
	  $(ls $ETC/action.d/*.sh $LIB/action.d/*.sh 2>/dev/null)
	do
		basename ${FILE%.sh}
	done | sort -u
}

status() {
	action status &>/dev/null
}

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


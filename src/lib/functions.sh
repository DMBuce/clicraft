#!bash

actionfile() {
	local ACTION="$1"

	if [ -f "$ETC/action.d/$ACTION.sh" ]; then
		echo "$ETC/action.d/$ACTION.sh"
	elif [ -f "$LIB/action.d/$ACTION.sh" ]; then
		echo "$LIB/action.d/$ACTION.sh"
	else
		echo "$PROG: Unknown action: $ACTION" >&2
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
			echo "${line#' '}"
		fi
	done <"$FILE"
}


#!bash

action() {
	ACTION="$1"
	shift

	if [ -f "$ETC/action.d/$ACTION-local.sh" ]; then
		. "$ETC/action.d/$ACTION-local.sh" "$@"
	elif [ -f "$ETC/action.d/$ACTION.sh" ]; then
		. "$ETC/action.d/$ACTION.sh" "$@"
	else
		echo "$PROG: Unknown action: $ACTION" >&2
	fi
}

status() {
	action status &>/dev/null
}


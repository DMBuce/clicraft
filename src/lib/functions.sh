#!bash

actionfile() {
	ACTION="$1"
	
	if [ -f "$ETC/action.d/$ACTION.sh" ]; then
		echo "$ETC/action.d/$ACTION.sh"
	elif [ -f "$LIB/action.d/$ACTION.sh" ]; then
		echo "$LIB/action.d/$ACTION.sh"
	else
		return 1
	fi
}

action() {
	ACTION="$1"
	shift

	FILE=$(actionfile "$ACTION")
	if [ $? = 0 ]; then
		. "$FILE" "$@"
	else
		echo "$PROG: Unknown action: $ACTION" >&2
		action help
	fi
}

status() {
	action status &>/dev/null
}


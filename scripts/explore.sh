#!bash
#
# This script requires mcexplore.
#
# Usage: clicraft explore <size> [x z]
#
#    Generates a world roughly <size> by <size> centered on coordinates
#    <x> and <z> (spawn by default) using mcexplore.
#

RADIUS="$(($1 / 16 + 1))"
x="$2"
z="$3"

# try to find mcexplore executable
MCEXPLORE="$(wickedwhich mcexplore mcexplore.py)" || return 1

# validate args
if [[ $# != 1 && $# != 3 ]]; then
	action help explore2
	return 1
elif ! [[ "$1" =~ ^[0-9]+$ && "$2" =~ ^-?[0-9]*$ && "$3" =~ ^-?[0-9]*$ ]]; then
	err "Arguments must be integers"
	return 1
fi

# abort with an error if the server is already running
if status; then
	err "You cannot run this while $SERVER_NAME is running."
	return 1
fi

# download server jar if needed
if [[ ! -f "$SERVER_JAR" ]]; then
	action dl
fi

if [[ "$x" != "" && "$z" != "" ]]; then
	$MCEXPLORE -p "$SERVER_DIR" -c "$START_COMMAND" -x "$x" -z "$z" "$RADIUS"
else
	$MCEXPLORE -p "$SERVER_DIR" -c "$START_COMMAND" "$RADIUS"
fi


#!bash
#
# This script requires mcexplore.
#
# Usage: clicraft explore <size> [args]
#
#    Generates a rectangle of land of a given <size> using mcexplore. By
#    default, <size> is measured in chunks. Any additional <args> get passed to
#    mcexplore. For valid <args>, see `mcexplore --help`.
#

# abort with an error if the server is already running
if status; then
	err "You cannot run this while $SERVER_NAME is running."
	return 1
fi

# try to find mcexplore executable
if ! MCEXPLORE=$(which mcexplore 2>/dev/null); then
	if ! MCEXPLORE=$(which mcexplore.py 2>/dev/null); then
		err "Cannot find mcexplore not in PATH";
		return 1
	fi
fi

# download server jar if needed
if [ ! -f "$SERVER_JAR" ]; then
	action dl
fi

$MCEXPLORE -p "$SERVER_DIR" -c "$START_COMMAND" "$@"


#!bash
#
# This script requires mcexplore.
#
# Usage: clicraft explore <size> [args]
#
#    Generates a rectangle of land of a given size. The <size> argument, as
#    well as all additional <args>, get passed directly to mcexplore. See
#    `mcexplore --help' for details.
#

# abort with an error if the server is already running
if status; then
	err "You cannot run this while $SERVER_NAME is running."
	return 1
fi

if [ ! -f "$SERVER_JAR" ]; then
	action init
fi

mcexplore -p "$SERVER_DIR" "$@"


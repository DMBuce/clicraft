#!bash
#
# This script requires c10t.
#
# Usage: clicraft map [args]
#
#    Maps the world using c10t. Any additional <args> get passed to c10t.
#    For valid <args>, see `c10t --help`.
#

# try to find c10t
C10T="$(wickedwhich c10t)" || return 1

# abort with an error if the server is already running
if status; then
	err "You cannot run this while $SERVER_NAME is running."
	return 1
fi

MAP_DIR="$HOME/maps"
LEVEL_NAME="$(serverprop 'level-name')"
FILE="$MAP_DIR/$LEVEL_NAME-$(date +%Y%m%d).png"

mkdir -p "$MAP_DIR"

$C10T -w "$SERVER_DIR/$LEVEL_NAME" -o "$FILE" "$@"


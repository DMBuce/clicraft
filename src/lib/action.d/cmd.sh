#!bash
#
# Usage: clicraft cmd <command>
#
#    Sends <command> to the server console.
#

CMD="$*"

action status >/dev/null && \
	tmux send -t "$SERVER_NAME" "${CMD#/}" C-m


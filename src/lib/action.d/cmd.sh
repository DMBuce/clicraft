#!bash
#
# Usage: clicraft cmd <command>
#
#    Sends <command> to the server console.
#

CMD="$*"

action status >/dev/null && \
	multiplex_cmd "${CMD#/}"


#!bash
#
# Usage: clicraft cmd [options] <command>
#
#    Sends <command> to the server console.
#
#    Options:
#
#       -q, --quiet     Suppress the output of <command>. This is the default.
#       -v, --verbose   Print the output of <command> to stdout.
#

VERBOSITY=0

# normalize options
if ! validopts "qv" "quiet" "verbose" -- "$@"; then
	action help "$ACTION"
	return 1
else
	set -- "${RETVAL[@]}"
fi
unset RETVAL

# parse options
while [[ "$1" == -* ]]; do
	case "$1" in
	  -q|--quiet)   VERBOSITY=0 ;;
	  -v|--verbose) VERBOSITY+=1 ;;
	  --)           shift; break ;;
	esac
	shift
done

CMD="${*#$CMD_LSTRIP}"

if [[ $# == 0 ]]; then
	action help "$ACTION"
	return 1
fi

# bail if server isn't running
action status >/dev/null || return $?

RE_PATTERN="$(str2val "RE_${CMD%% *}" upper)"

if [[ "$RE_PATTERN" != "" ]]; then
	if [[ "$VERBOSITY" != 0 ]]; then
		TIMEOUT=$CMD_TIMEOUT serverlog "$RE_PATTERN" cmd "$CMD"
	else
		TIMEOUT=$CMD_TIMEOUT serverlog "$RE_PATTERN" cmd "$CMD" >/dev/null
	fi
else
	if [[ "$VERBOSITY" != 0 ]]; then
		# send command to the server and print server log for 2 seconds
		TIMEOUT=$CMD_TIMEOUT serverlog 1000 cmd "$CMD"
	else
		# send command to the server
		cmd "$CMD"
	fi
fi


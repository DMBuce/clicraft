#!bash
#
# Usage: clicraft cmd [-q|-v] <command>
#
#    Sends <command> to the server console.
#

VERBOSITY=0

# parse options
while [[ "${1:0:1}" == '-' ]]; do
	case "$1" in
	  "-q"|"--quiet")   VERBOSITY=0 ;;
	  "-v"|"--verbose") VERBOSITY+=1 ;;
	  "--") break ;;
	  *)
		action help "$ACTION"
		return 1
	  ;;
	esac
	shift
done

CMD="${*#$CMD_LSTRIP}"

if [[ $# == 0 ]]; then
	action help "$ACTION"
	return 1
fi

action status >/dev/null
retval=$?

# bail if server isn't running
if [[ "$retval" != 0 ]]; then
	return $retval
fi

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


#!bash
#
# Usage: clicraft restart [-w|--warn]
#
#    Restarts the server. With --warn, broadcasts a warning in chat first.
#

broadcast() {
	cmd say "$*"
	msg "$*"
}

# normalize options
shortopts="w"
longopts=("warn")
if ! validopts "$shortopts" "${longopts[@]}" -- "$@"; then
	action help "$ACTION"
	return 1
else
	set -- "${RETVAL[@]}"
fi
unset RETVAL
unset shortopts
unset longopts

# parse options
WARN=0
while [[ "$1" == -* ]]; do
	case "$1" in
	  -w|--warn)       WARN=1 ;;
	  --)              shift; break ;;
	esac
	shift
done

if (( WARN )) && status; then
	broadcast "Restarting in 15 seconds"
	sleep 5
	broadcast "Restarting in 10 seconds"
	sleep 5
	broadcast "Restarting in 5 seconds"
	sleep 2
	broadcast "3..."
	sleep 1
	broadcast "2..."
	sleep 1
	broadcast "1..."
	sleep 1
	cmd say "The server is going down NOW"
fi

action stop
action start


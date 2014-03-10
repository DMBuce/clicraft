#!bash
#
# Usage: clicraft enable [options] <action> [name]
#
#    Enables the example <action>. If <name> is given, the new action script
#    is installed using that name.
#
#    Options:
#
#       -c, --copy      Install with a copy of the example action script.
#       -s, --symlink   Install using a symlink to the example action script.
#                       This is the default.
#

# normalize options
shortopts="cs"
longopts=("copy" "symlink")
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
SYMLINK=1
while [[ "$1" == -* ]]; do
	case "$1" in
	  -c|--copy)    SYMLINK=0 ;;
	  -s|--symlink) SYMLINK=1 ;;
	  --)           shift; break ;;
	esac
	shift
done

action="${1%.sh}"
name="${2%.sh}"
name="${name:-$action}"

if [[ ! -f "$CLICRAFT_CONFIG/action.d/$action.sh.example" ]]; then
	err "File does not exist: %s" "$CLICRAFT_CONFIG/action.d/$action.sh.example"
	return 1
fi

if (( SYMLINK )); then
	if [[ -h "$CLICRAFT_CONFIG/action.d/$name.sh" ]]; then
		return 0
	elif [[ -f "$CLICRAFT_CONFIG/action.d/$name.sh" ]]; then
		rm "$CLICRAFT_CONFIG/action.d/$name.sh"
	fi

	echo ln -s "$action.sh.example" "$CLICRAFT_CONFIG/action.d/$name.sh"
	ln -s "$action.sh.example" "$CLICRAFT_CONFIG/action.d/$name.sh"
else
	if [[ -h "$CLICRAFT_CONFIG/action.d/$name.sh" ]]; then
		rm "$CLICRAFT_CONFIG/action.d/$name.sh"
	elif [[ -f "$CLICRAFT_CONFIG/action.d/$name.sh" ]]; then
		return 0
	fi

	echo cp "$CLICRAFT_CONFIG/action.d/$action.sh.example" "$CLICRAFT_CONFIG/action.d/$name.sh"
	cp "$CLICRAFT_CONFIG/action.d/$action.sh.example" "$CLICRAFT_CONFIG/action.d/$name.sh"
fi


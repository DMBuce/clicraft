#!bash
#
# Usage: clicraft help [action]
#
#    Displays usage information for <action>. If no <action> is given,
#    clicraft usage is displayed instead.
#

__usage() {
	local ACTIONS=( $(actions) )
	cat <<EOF
Usage: $PROG <action> [args]

   Performs some action for the minecraft server. <action> can be one of:
      ${ACTIONS[@]}

   To get usage for a particular action, run \`$PROG help <action>'.
   For bug reports, use <$BUGREPORT>.

EOF
}

if [ $# != 0 ] && FILE=$(actionfile "$1"); then
	usage "$FILE"
else
	__usage
fi


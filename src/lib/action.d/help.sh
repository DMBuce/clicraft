#!bash
#
# Usage: clicraft help [action]
#
#    Displays usage information for <action>. If no <action> is given,
#    clicraft usage is displayed instead.
#

__getactions() {
	local FILE
	for FILE in \
	  $(ls $ETC/action.d/*.sh $LIB/action.d/*.sh 2>/dev/null)
	do
		basename ${FILE%.sh}
	done | sort -u
}

__usage() {
	local ACTIONS=( $(__getactions) )
	cat <<EOF
Usage: $PROG <action> [args]

   Performs some action for the minecraft server. <action> can be one of:
      ${ACTIONS[@]}

   To get usage for a particular action, run \`$PROG help <action>'.

EOF
}

if [ $# != 0 ] && FILE=$(actionfile "$1"); then
	usage "$FILE"
else
	__usage
fi


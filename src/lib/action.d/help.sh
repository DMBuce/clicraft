#!bash
#
# Usage: clicraft help [action]
#
#    Displays usage information for <action>. If no <action> is given,
#    clicraft usage is displayed instead.
#

__usage() {
	local ACTIONS=( $(actions) )
	fmt -s <<EOF
Usage: $PROG [options] <action> [args]

   Performs some action for the minecraft server. <action> can be one of:

      ${ACTIONS[@]}

   Valid <options> are:

      -c, --config=<config>   Use a different <config> directory.

      -h, --help              Display this help message and exit.

      -V, --version           Display the version and exit.

      -x, --xtrace            Set bash's xtrace option for debugging.

   To get usage for a particular action, run \`$PROG help <action>'. For
   bug reports, use <$BUGREPORT>.

EOF
}

if [[ $# != 0 ]]; then
	usage "$1"
else
	__usage
fi


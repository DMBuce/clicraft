#!bash
#
# Useful for debugging
#
# Usage: clicraft sh [command]
#
#    Evaluate <command> within clicraft's environment. If no <command> is given,
#    open a shell with an environment that mimics clicraft's.
#

if [[ $# != 0 ]]; then
	eval "$*"
else

	# make new variables exported by default
	set -a

	# action() normally sets this as a local variable,
	# so we need to reset it here
	ACTION=$ACTION

	# re-run bootstrap code
	. <(sed -nr '/^PROG=/,/^# end envsetup/ p' "$0")

	# open new shell
	bash
fi


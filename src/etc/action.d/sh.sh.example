#!bash
#
# Useful for debugging
#
# Usage: clicraft sh [command]
#
#    Evaluate <command> within clicraft's environment. If no <command> is given,
#    open an interactive bash session with an environment that mimics clicraft's.
#

if [[ $# != 0 ]]; then
	eval "$*"
else

	# open new shell
	bash --init-file <(echo '[[ -f ~/.bashrc ]] && . ~/.bashrc'
	                   echo "export PS1='clicraft> '"
	                   sed -nr '/^PROG=/,/^trap/ p' "$0"
	                   echo "ACTION=$ACTION")
fi


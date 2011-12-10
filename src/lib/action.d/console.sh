#!bash
#
# Usage: clicraft console
#
#    Attaches to the clicraft console. Use `Ctrl-b d' to detach.
#

action status >/dev/null && \
	exec tmux attach -t "$SERVER_NAME"


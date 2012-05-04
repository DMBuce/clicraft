#!bash
#
# Usage: clicraft console
#
#    Attach to the server console. This places you in the tmux session that the
#    server is running in. All normal tmux key-bindings (like `Ctrl-b d' to
#    detach) should work.
#

action status >/dev/null && \
	exec tmux attach -t "$SERVER_NAME"


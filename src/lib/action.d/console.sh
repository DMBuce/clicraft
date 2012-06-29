#!bash
#
# Usage: clicraft console
#
#    Attach to the server console. This places you in the multiplexer shell
#    session that the server is running in. All normal multiplexer key-bindings
#    (like `Ctrl-b d' or `Ctrl-a d' to detach) should work.
#

action status >/dev/null && \
	multiplex_console


if [[ ! -f "$EXECDIR/$MULTIPLEXER.sh" ]]; then
	warn "Invalid multiplexer: $MULTIPLEXER"
	MULTIPLEXER="$(which tmux 2>/dev/null || which screen 2>/dev/null)"
	if [[ "$MULTIPLEXER" != "" ]]; then
		warn "Falling back to $MULTIPLEXER"
	else
		exit 1
	fi
fi

if [[ ! -f "$DB" ]]; then
	warn "Can't find redb for $SERVER_TYPE"
	warn "Falling back to minecraft.tab"
	DB="$CONFDIR/redb/minecraft.tab"
fi

if [[ ! "$TIMEOUT" =~ ^[+-]?[0-9]+$ ]]; then
	warn "Invalid timeout: $TIMEOUT"
	warn "Falling back to 20"
	TIMEOUT=20
fi

for timeout in START_TIMEOUT STOP_TIMEOUT CMD_TIMEOUT; do
	if [[ ! "${!timeout}" =~ ^[+-]?[0-9]+$ ]]; then
		warn "Invalid timeout: ${!timeout}"
		warn "Falling back to $TIMEOUT"
		declare "$timeout=$TIMEOUT"
	fi
done
unset timeout


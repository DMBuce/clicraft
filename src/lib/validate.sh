if [[ ! -f "$EXECDIR/$MULTIPLEXER.sh" ]]; then
	warn "Invalid multiplexer: $MULTIPLEXER"
	MULTIPLEXER="$(which tmux 2>/dev/null || which screen 2>/dev/null)"
	if [[ "$MULTIPLEXER" != "" ]]; then
		warn "Falling back to $MULTIPLEXER"
	else
		exit 1
	fi
fi

if [[ ! -f "$REDB" ]]; then
	warn "Can't find redb for $SERVER_TYPE"
	warn "Falling back to minecraft.tab"
	REDB="$CONFDIR/redb/minecraft.tab"
fi

# expose redb as RE_* variables
RE_TIMESTAMP=$(redb_lookup 'timestamp')
while IFS='\n' read -r keyval; do
	key="${keyval%% *}"
	value="${keyval#$key }"
	# if given a prefix, prepend it to the regex after start-of-line
	if [[ "${value:0:2}" = '^^' ]]; then
		value="^${RE_TIMESTAMP}${value:2}"
	fi
	declare "$(str2var "RE_$key" upper)=$value"
done < "$REDB"
unset keyval key value

if [[ "$RE_START" = "" ]]; then
	warn "Key not found in database: start"
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


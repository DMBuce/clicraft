if [[ ! -f "$EXECDIR/$MULTIPLEXER.sh" ]]; then
	warn "Invalid multiplexer: %s" "$MULTIPLEXER"
	MULTIPLEXER="$(command -v tmux || command -v screen)"
	if [[ "$MULTIPLEXER" != "" ]]; then
		warn "Falling back to %s" "$MULTIPLEXER"
	else
		exit 1
	fi
fi

if [[ ! -f "$REDB" ]]; then
	warn "Can't find redb for %s" "$SERVER_TYPE"
	warn "Falling back to %s" "minecraft.tab"
	REDB="$CONFDIR/redb/minecraft.tab"
fi

# expose redb as RE_* variables
RE_TIMESTAMP=$(redb_lookup 'timestamp')
while IFS='\n' read -r keyval; do
	key="${keyval%% *}"
	value="${keyval#$key }"
	# if given a prefix, prepend it to the regex after start-of-line
	if [[ "$value" == '^^'* ]]; then
		value="^${RE_TIMESTAMP}${value#'^^'}"
	fi
	declare "$(str2var "RE_$key" upper)=$value"
done < "$REDB"
unset keyval key value

if [[ "$RE_START" == "" ]]; then
	warn "Key not found in database: %s" "start"
fi

if [[ ! "$TIMEOUT" =~ ^[+-]?[0-9]+$ ]]; then
	warn "Invalid timeout: %s" "$TIMEOUT"
	warn "Falling back to %d" "20"
	TIMEOUT=20
fi

for timeout in START_TIMEOUT STOP_TIMEOUT CMD_TIMEOUT; do
	if [[ ! "${!timeout}" =~ ^[+-]?[0-9]+$ ]]; then
		warn "Invalid timeout: %s" "${!timeout}"
		warn "Falling back to %d" "$TIMEOUT"
		declare "$timeout=$TIMEOUT"
	fi
done
unset timeout


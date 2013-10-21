#!/bin/bash
#
# This script requires mmat.
#
# Usage: clicraft prune [dim]
#
#    Prunes the map using mmat. Valid values for <dim> are overworld,
#    nether, or end.
#

dim="${1-overworld}"

MMAT_JAR="${MMAT_JAR-$SERVER_DIR/mmat.jar}"
PRUNE_RADIUS="${PRUNE_RADIUS-15}"
OVERWORLD_WHITELIST="${OVERWORLD_WHITELIST-$CONFDIR/overworld-blocks.conf}"
NETHER_WHITELIST="${NETHER_WHITELIST-$CONFDIR/nether-blocks.conf}"
END_WHITELIST="${END_WHITELIST-$CONFDIR/end-blocks.conf}"

mmat() {
	java -jar "$MMAT_JAR" "$@"
}

blocklist() {
	local dim="$1"
	local file="$(blockfile "$dim")"
	sed -nr '/^[0-9]+\w|^[0-9]+$/ s/[^0-9].*//p' "$file" | tr '\n' ',' | sed 's/,*$//'
}

blockfile() {
	local dim="$1"
	local WHITELIST="${dim^^}_WHITELIST"
	echo "${!WHITELIST}"
}

world="$(dimdir "$dim")" || return 1
mmat -w "$world" -d "$PRUNE_RADIUS" -p "$(blocklist "$dim")"


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

WORLD="$(serverprop level-name)" || return 1

mmat() {
	java -jar "$MMAT_JAR" "$@"
}

dimdir() {
	local world dim
	world="$1"
	dim="$2"

	if [[ "$dim" == overworld ]]; then
		echo "$SERVER_DIR/$world"
	elif [[ "$dim" == nether && "$SERVER_TYPE" == minecraft ]]; then
		echo "$SERVER_DIR/$world/DIM-1"
	elif [[ "$dim" == nether ]]; then
		echo "$SERVER_DIR/$world"_nether
	elif [[ "$dim" == end && "$SERVER_TYPE" == minecraft ]]; then
		echo "$SERVER_DIR/$world/DIM1"
	elif [[ "$dim" == end ]]; then
		echo "$SERVER_DIR/$world"_the_end
	else
		echo "$SERVER_DIR/${world}_${dim}"
	fi
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

mmat -w "$(dimdir "$WORLD" "$dim")" -d "$PRUNE_RADIUS" -p "$(blocklist "$dim")"


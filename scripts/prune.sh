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

DEFAULT_OVERWORLD_WL=19,20,22,25,26,27,28,41,42,45,57,63,68,71,75,76,77,80,\
84,87,88,89,91,92,95,96,103,104,105,107,108,109,112,113,114,115,116,117,121,122,\
123,124,125,126,130,133,135,136,137,138,139,143,144,145,146,147,148,149,150,\
151,152,153,154,155,156,157,158,159,170,171,172,173
DEFAULT_NETHER_WL=1,2,3,4,5,6,8,9,12,14,15,16,17,18,19,20,21,22,23,24,25,26,\
27,28,29,30,31,32,33,34,35,37,38,41,42,43,45,46,47,48,50,52,53,55,56,\
57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,\
82,83,84,85,86,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,\
108,109,110,111,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,\
131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,\
150,151,152,154,155,156,157,158,159,170,171,172,173
DEFAULT_END_WL=1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,\
25,26,27,28,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,46,47,48,50,52,\
53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,\
78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,\
102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,120,122,\
123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,\
142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,170,\
171,172,173

OVERWORLD_WHITELIST="${OVERWORLD_WHITELIST-$DEFAULT_OVERWORLD_WL}"
NETHER_WHITELIST="${NETHER_WHITELIST-$DEFAULT_NETHER_WL}"
END_WHITELIST="${END_WHITELIST-$DEFAULT_END_WL}"
PRUNE_RADIUS="${PRUNE_RADIUS-15}"

WORLD="$(serverprop level-name)"

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
	local WHITELIST="${dim^^}_WHITELIST"
	echo "${!WHITELIST}"
}

mmat -w "$(dimdir "$WORLD" "$dim")" -d "$PRUNE_RADIUS" -p "$(blocklist "$dim")"


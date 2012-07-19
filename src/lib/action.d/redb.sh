#!bash
#
# Usage: clicraft redb lookup <key>
#        clicraft redb insert <key> <value>
#        clicraft redb update <key> <value>
#        clicraft redb delete <key>
#
#    Manipulate the regex database.
#

REDB_ACTION="$1"
KEY="$2"
shift 2
VALUE="$*"

redb_file() {
	while read line; do
		action redb $line
	done
}

case "$REDB_ACTION" in
  lookup) redb_lookup "$KEY" ;;
  insert) redb_insert "$KEY" "$VALUE" ;;
  update) redb_update "$KEY" "$VALUE" ;;
  delete) redb_delete "$KEY" ;;
  "")     redb_file ;;
  *)      action help redb ;;
esac


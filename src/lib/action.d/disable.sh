#!bash
#
# Usage: clicraft disable <action>.
#
#    Disables an <action> script created by the user.
#

action="${1%.sh}"

if ! file="$(local_actionfile "$action")"; then
	err "File not found: %s" "$CLICRAFT_CONFIG/action.d/$action.sh"
elif [[ -h "$file" ]]; then
	rm "$file"
elif [[ -f "$file.example" ]]; then
	mv "$file" "$file.ccback"
else
	mv "$file" "$file.example"
fi


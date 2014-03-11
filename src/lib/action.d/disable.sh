#!bash
#
# Usage: clicraft disable <action>.
#
#    Disables an <action> script created by the user.
#

action="${1%.sh}"

if ! file="$(local_actionfile "$action" 2>/dev/null)"; then
	return
elif [[ -h "$file" ]] \
	|| diff -q "$file" "$file.example" >/dev/null
then
	msg "%s" "rm '$file'"
	rm "$file"
elif [[ -f "$file.example" ]]; then
	msg "%s" "mv '$file' '$file.ccback'"
	mv "$file" "$file.ccback"
else
	msg "%s" "mv '$file' '$file.example'"
	mv "$file" "$file.example"
fi


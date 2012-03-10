#!bash
#
# Usage: clicraft edit [file|action]
#
#    Edit <file> in the minecraft server directory. If <file> does not exist,
#    edit the <action>.sh script instead. If <action>.sh does not exist, create
#    it with a useful template.
#
#    When no <file> or <action> is present, edit clicraft's configuration file.
#
#    Uses $EDITOR to edit files, or vi if $EDITOR is undefined.
#

edit_file() {
	local EDITOR="${EDITOR-vi}"
	$EDITOR "$1"
}

# edit FILE created from SUBST applied to TEMPLATE
edit_file_template() {
	local TEMPLATE FILE SUBST
	TEMPLATE="$1"
	FILE="$2"
	SUBST="$3"

	# if file exists, just edit it
	# otherwise, create it from a template before editing
	if [ -f "$FILE" ]; then
		edit_file "$FILE"
	else
		if [ -f "$TEMPLATE" ]; then
			sed "$SUBST" "$TEMPLATE" >>"$FILE"
		else
			warn "Template file $TEMPLATE not found"
		fi

		edit_file "$FILE"

		if diff -q "$FILE" <(sed "$SUBST" "$TEMPLATE") &>/dev/null
		then
			rm "$FILE"
		fi
	fi
}

edit_action() {
	local ACTION ACTIONFILE TEMPLATE
	ACTION="$1"

	if ACTIONFILE="$(local_actionfile "$ACTION" 2>/dev/null)"; then
		edit_file "$ACTIONFILE"
	else
		ACTIONFILE="$CONFDIR/action.d/$ACTION.sh"

		# figure out which template to use
		if sys_actionfile "$ACTION" &>/dev/null; then
			TEMPLATE="$CONFDIR/action.d/action-override.sh.example"
		else
			TEMPLATE="$CONFDIR/action.d/action.sh.example"
		fi

		edit_file_template "$TEMPLATE" "$ACTIONFILE" "s/\$ACTION/$ACTION/g"
	fi
}

if [ "$1" = "" ]; then
	# edit clicraft.conf
	edit_file_template "$CONFDIR/clicraft-defaults.conf" "$CONFDIR/clicraft.conf"
elif [ -f "$SERVER_DIR/$1" ]; then
	edit_file "$SERVER_DIR/$1"
else
	edit_action "$1"
fi


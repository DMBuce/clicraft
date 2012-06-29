#!bash
#
# Usage: clicraft edit [file|action]
#
#    Edit <file> in the server directory. If <file> does not exist, edit the
#    action script for <action> instead. If an action script for <action> does
#    not exist, create it with a useful template.
#
#    When no <file> or <action> is present, edit clicraft.conf.
#
#    This command launches EDITOR to edit files, or vi if the EDITOR variable
#    is not defined in your environment.
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

		# if any non-comment, non-whitespace changes were made
		if [ -f "$TEMPLATE" ] && \
		   diff -q <(grep "^[ 	]*[^ 	#]" "$FILE") \
		           <(grep "^[ 	]*[^ 	#]" "$TEMPLATE" | sed "$SUBST") >/dev/null; then
			warn "Aborting installation of $(basename "$FILE"): No changes made to template."
			rm "$FILE"
		else
			msg "New file $(basename "$FILE") successfully installed."
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


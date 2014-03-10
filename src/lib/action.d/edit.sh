#!bash
#
# Usage: clicraft edit [file|action]
#
#    Without <file> or <action>, edit clicraft.conf. If <file> exists in the
#    server directory, edit it. If vinbt is installed, <file> has a .dat
#    extension, and it exists in the world directory, edit <file> with vinbt.
#    Otherwise, edit the action script for <action>. If the script does not
#    already exist, create it with an appropriate template.
#
#    This command launches EDITOR to edit files, or vi if the EDITOR variable
#    is not defined in your environment.
#

# main starting point for script
main() {
	local file action template world vinbt nbtfile
	file="$1"
	action=
	template=

	# figure out the file to edit and the template to use
	if [[ -z "$file" ]]; then
		file="$CLICRAFT_CONFIG/clicraft.conf"
		template="$CLICRAFT_CONFIG/clicraft-defaults.conf"
	elif [[ -f "$SERVER_DIR/$file" ]]; then
		file="$SERVER_DIR/$file"
	elif [[ "$file" == *.dat ]] \
		&& world="$(serverprop level-name 2>/dev/null)" \
		&& vinbt="$(wickedwhich vinbt vinbt.sh 2>/dev/null)" \
		&& nbtfile="$(find "$SERVER_DIR/$world" -name "$file" | head -n1)" \
		&& [[ -n "$nbtfile" ]]
	then
		file="$nbtfile"
		$vinbt "$file"
		return $?
	elif [[ -f "$CLICRAFT_CONFIG/action.d/${file%.sh}.sh.example" ]]; then
		file="$CLICRAFT_CONFIG/action.d/${file%.sh}.sh"
		template="$file.example"
	elif sys_actionfile "${file%.sh}" &>/dev/null; then
		action="${file%.sh}"
		file="$CLICRAFT_CONFIG/action.d/$action.sh"
		template="$CLICRAFT_CONFIG/action.d/action-override.sh.example"
	else
		action="${file%.sh}"
		file="$CLICRAFT_CONFIG/action.d/$action.sh"
		template="$CLICRAFT_CONFIG/action.d/action.sh.example"
	fi

	if [[ -n "$template" && -n "$action" ]]; then
		edit_from_template "$file" "$template" "s/\\\$ACTION/$action/g"
	elif [[ -n "$template" ]]; then
		edit_from_template "$file" "$template"
	else
		edit_file "$file"
	fi
}

# edit file using EDITOR
edit_file() {
	local file fileorig
	file="$1"

	${EDITOR-vi} "$file"

	if [[ -f "$file" && ! -s "$file" ]]; then
		warn "Removing empty file %s" "$file"
		rm -f "$file"
	fi
}

# edit file from template
edit_from_template() {
	local file template action
	file="$1"
	template="$2"
	subst="$3"

	# edit file if it already exists
	if [[ -f "$file" ]]; then
		edit_file "$file"
		return $?
	fi

	# create file from template
	if [[ -f "$template" ]]; then
		# file shouldn't exist, so abort if it does
		if ! ( set -o noclobber
		       sed -r "$subst" "$template" >"$file" )
		then
			err "Unexpected error encountered. Aborting."
			exit 1
		fi
	else
		warn "Template file %s not found" "$template"
	fi

	edit_file "$file"
	if [[ ! -f "$file" ]]; then
		return $?
	fi

	if [[ -f "$template" ]] && \
		diff -q "$file" <(sed -r "$subst" "$template") >/dev/null
	then
		warn "Aborting installation of %s: No changes made to template." "${file##*/}"
		rm "$file"
	else
		msg "New file %s successfully installed." "${file##*/}"
	fi
}

main "$@"


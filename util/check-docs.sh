#!/bin/bash

# start from project base
cd $(dirname $0)/..

# Prints an error to stderr
err() {
	local mesg=$1; shift
	printf "${mesg}\n" "$@" >&2
}

# print list of system actions
sys-actions() {
	find src/lib/action.d -maxdepth 1 -name \*.sh | \
		sed 's|\.sh$||; s|.*/||;'
}

# print list of example actions
example-actions() {
	find src/etc/action.d -maxdepth 1 -name \*.sh.example | \
		sed 's|\.sh\.example$||; s|.*/||;'
}

# print list of functions
fns() {
	grep -o '[^ =]*()' src/lib/functions.sh | sed 's/()$//'
}

# print list of options
options() {
	cat src/etc/clicraft-defaults.conf.in src/lib/defaults.sh.in \
	    src/etc/clicraft-defaults.conf    src/lib/defaults.sh  | \
		egrep -o '^\s*[a-zA-Z_]*=' | sed -r 's|^\s*||; s|=$||' | sort -u
}

# print list of *.in files
infiles() {
	find *.in scripts src -name \*.in
}

# check if system actions are documented in clicraft.1
for action in $(sys-actions); do
	grep -q "^\*$action\*" doc/clicraft.1.txt || \
		err "$action.sh not documented in clicraft.1.txt"
done

# check if example actions are documented in clicraft-examples.1
for action in $(example-actions | grep -v '^action'); do
	grep -q "^\*$action\*" doc/clicraft-examples.1.txt || \
		err "$action.sh.example not documented in clicraft-examples.1.txt"
done

# check if functions are documented in clicraft-actions.5
for fn in $(fns); do
	grep -q "^\*$fn\*" doc/clicraft-actions.5.txt || \
		err "$fn() not documented in clicraft-actions.5.txt"
done

# check if options are documented in clicraft.conf.5
# and mentioned in clicraft-actions.5
for opt in $(options); do
	grep -q "^\s*$opt=" src/etc/clicraft-defaults.conf.in || \
		err "$opt not defined in clicraft-defaults.conf.in"
	grep -q "^\s*$opt=" src/lib/defaults.sh.in || \
		err "$opt not defined in defaults.sh.in"
	grep -q "^\*\*$opt=\*\*" doc/clicraft.conf.5.txt || \
		err "$opt not documented in clicraft.conf.5.txt"
	egrep -q "( |\*)$opt(,|\*)" doc/clicraft-actions.5.txt || \
		err "$opt not documented in clicraft-actions.5.txt"
done

# check if *.in match *
for file in $(infiles); do
	[[ -f "${file%.in}" ]] || continue
	badlines="$(diff "${file%.in}" "$file" | grep '^>' | egrep -v '@[a-zA-Z_0-9]*@|^> $')"
	if [[ "$badlines" != "" ]]; then
		err "Code found in ${file%.in} but not $file:"
		err "$badlines"
	fi
done


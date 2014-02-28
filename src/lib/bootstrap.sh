#!bash

# Prints an info message to stdout
msg() {
	local mesg=$1
	shift

	printf -- "${mesg}\n" "$@"
}

# Prints a warning to stderr
warn() {
	local mesg=$1
	shift

	printf -- "${mesg}\n" "$@" >&2
}

# Prints an error to stderr
err() {
	local mesg=$1
	shift

	printf -- "${mesg}\n" "$@" >&2
}

shortopts() {
	local c
	for c in $(fold -w1 <<< "${1#-}"); do
		printf -- "-$c "
	done
}


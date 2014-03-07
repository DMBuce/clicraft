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

# Validates and normalizes options
validopts() {
	local o i opt arg shortopts longopts
	shortopts="$1"
	longopts=()
	RETVAL=()
	opt=
	arg=
	shift

	while [[ "$1" != '--' ]]; do
		longopts+=("$1")
		shift
	done
	shift

	while [[ "$1" == -* ]]; do
		opt="$1"
		case "$opt" in
		  --)
			break
		  ;;
		  --*)
			if [[ "$opt" == *=* ]]; then
				arg="${opt#*=}"
				opt="${opt%%=*}"
			fi

			if [[ "${longopts[*]}" =~ ( |^)"${opt#--}":?( |$) ]]; then
				RETVAL+=("$opt")
			else
				err "Unknown option: %s" "$opt"
				return 1
			fi

			if [[ "${longopts[*]}" == *${opt#--}:* ]]; then
				if [[ -n "$arg" ]]; then
					RETVAL+=("$arg")
				elif (( $# > 1 )); then
					shift
					RETVAL+=("$1")
				else
					err "Option requires argument: %s" "$opt"
					return 1
				fi
			fi
			shift
		  ;;
		  -*)
			for ((i=1; i<${#opt}; i++)); do
				o="${opt:i:1}"
				if [[ "$shortopts" == *$o* ]]; then
					RETVAL+=("-$o")
				else
					err "Unknown option: %s" "-$o"
					return 1
				fi

				if [[ "$shortopts" == *$o:* ]]; then
					if (( i == ${#opt} - 1 )); then
						shift
						if (( $# )); then
							RETVAL+=("$1")
						else
							err "Option requires argument: %s" "-$o"
							return 1
						fi
					else
						RETVAL+=("${opt:i+1}")
						break
					fi
				fi
			done
			shift
		  ;;
		esac
	done
	RETVAL+=("$@")
}


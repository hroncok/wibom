#!/usr/bin/env bash
# wibom script to running an application in a bottle
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]

USAGE="Usage: wibom runin [--script script_path] bottle_path commands [arguments]"

BOTTLES="$HOME/.local/share/bottles"

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "$USAGE"
	exit 1
fi

if [ "$1" == "--script" ]; then
	scriptpath="$2"
	shift 2
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "$USAGE"
		exit 1
	fi
	echo "#!/usr/bin/env bash" > "$scriptpath"
	echo cd \"`pwd`\" >> "$scriptpath"
fi

# Checking if $1 is a bottle
if [ -e "$1/user.reg" ] && [ -e "$1/system.reg" ] && [ -d "$1/drive_c" ]; then
	absolute1=`cd "$1"; pwd` # We need absolute path (little hack)
	export WINEPREFIX="$absolute1"
	if [ "$scriptpath" ]; then
		echo "export WINEPREFIX=\"$absolute1"\" >> "$scriptpath"
	fi
	command="$2" # Hold it
	shift 2 # Drop it
	$command "$@" # Use it
	if [ "$scriptpath" ]; then
		line=$command
		# All arguments should have their own \" \"
		for arg in "$@"
		do
			line="${line}"" \"${arg}\""
		done
		echo "$line" >> "$scriptpath"
		echo exit '$?' >> "$scriptpath"
		chmod a+x "$scriptpath" # Executable
	fi
	exitcode=$? # Remember the exitcode now
	if [ $exitcode == 127 ]; then
		echo "Command $command not found."
	fi
	exit $exitcode
else
	echo "Error: $1 is not a wine bottle"
	exit 5
fi

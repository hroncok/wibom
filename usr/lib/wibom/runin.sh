#!/usr/bin/env bash
# wibom script to running an application in a bottle
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]

USAGE="Usage: wibom runin bottle_path commands [arguments]"

BOTTLES="$HOME/.local/share/bottles"

if [ -z "$1" ] || [ -z "$2" ]; then
	echo $USAGE
	exit 1
fi

# Checking if $1 is a bottle
if [ -e $1/user.reg ] && [ -e $1/system.reg ] && [ -d $1/drive_c ]; then
	absolute1="$(cd $1; pwd)" # We need absolute path (little hack)
	export WINEPREFIX="$absolute1"
	command="$2" # Hold it
	shift 2 # Drop it
	$command "$@" # Use it
	exitcode="$?"
	if [ $exitcode == 127 ]; then
		echo "Command $command not found."
		# Setting back to default, if something bad happens
		export WINEPREFIX=""
		exit 127
	elif [ $command == "wine" ] && [ $exitcode == 126 ]; then
		export WINEPREFIX=""
		exit 126
	elif [ $command == "wine" ] && [ $exitcode == 139 ]; then
		export WINEPREFIX=""
		exit 139
	else
		export WINEPREFIX=""
	fi
else
	echo "Error: $1 is not a wine bottle"
	exit 5
fi

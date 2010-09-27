#!/usr/bin/env bash
# wibom script to creating a bottle from default or any other bottle
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]

USAGE="Usage: wibom new bottle_path [parent_bottle_path]"

BOTTLES="$HOME/.local/share/bottles"

if [ -z "$1" ]; then
	echo "$USAGE"
	exit 1
fi

if [ -e "$1" ]; then
	#Directory exists, lets's control it
	if ! [ -d "$1" ]; then
		# Checking if firts param is a directory
		echo "Error: $1 exists, but is not a directory"
		echo "$USAGE"
		exit 4
	fi
	if ! [ -z `ls -A "$1"` ]; then
		# Checking if firts param is an empty directory
		echo "Error: $1 is not an empty directory"
		exit 8
	fi
else
	# Directory doesn't exist, let's create it
	mkdir "$1"
fi

# If not specified, take default
if [ -z "$2" ]; then
	parent="$BOTTLES/default"
else
	parent="$2"
fi

if [ "$parent" != "$BOTTLES/default" ]; then
	if ! ([ -e "$parent/user.reg" ] && [ -e "$parent/system.reg" ] && [ -d "$parent/drive_c" ]); then
		# Parent is not a bottle
		echo "Error: $2 is not a bottle"
		echo "$USAGE"
		exit 5
	fi
fi

# Copy files regulary
cp -R "$parent"/*  "$1"
echo "Bottle $1 was created"

# Add an item to the list
absolute1=`cd "$1"; pwd` # We need absolute path (little hack)
if [ `grep -x "$absolute1" "$BOTTLES/bottles.lst"` ]; then
	echo "Bottle has already been in bottles.lst (means something was messed up)"
else
	echo "$absolute1" >> "$BOTTLES/bottles.lst"
	echo "New bottle was added to bottles.lst"
fi
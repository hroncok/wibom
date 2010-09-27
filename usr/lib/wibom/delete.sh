#!/usr/bin/env bash
# wibom script to deleting a bottle
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]

USAGE="Usage: wibom delete bottle_path"

BOTTLES="$HOME/.local/share/bottles"

if [ -z "$1" ]; then
	echo "$USAGE"
	exit 1
fi

absolute1=`cd "$1"; pwd` # We need absolute path (little hack)

# Test if the given bottle is in the list
if [ `grep -x "$absolute1" "$BOTTLES/bottles.lst"` ]; then
	# Returm into the list all the other bottles
	cp "$BOTTLES/bottles.lst" "$BOTTLES/bottles.lst.old"
	grep -vx "$absolute1" "$BOTTLES/bottles.lst.old" > "$BOTTLES/bottles.lst"
	echo "Bottle $1 was deleted from the list"
	if ! [ "$(which trash)" ]; then
		echo "It is recommanded to install trash-cli. Directory $1 was deleted forever."
		rm -rf "$1"
	else
		trash "$1"
		echo "Directory $1 was deleted, you can found it in trash."
	fi
else
	echo "$1 is not a bottle on the list, delete the directory manualy"
	echo "$USAGE"
	exit 5
fi
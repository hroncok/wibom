#!/usr/bin/env bash
# wibom script to deleting a bottle
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]

USAGE="Usage: wibom import bottle_path"

BOTTLES="$HOME/.local/share/bottles"

if [ -z "$1" ]; then
	echo $USAGE
	exit 1
fi

if ! [ -d $1 ]; then
	echo "Error: $1 is not a directory"
	echo $USAGE
	exit 4
fi

absolute1="$(cd $1; pwd)" # We need absolute path (little hack)
if [ $absolute1 == $BOTTLES/default ]; then
	echo "Default bottle should not be on the list! It cannot be imported."
	exit 6
fi

if [ -e $1/user.reg ] && [ -e $1/system.reg ] && [ -d $1/drive_c ]; then
	if [ "$(grep -x $absolute1 $BOTTLES/bottles.lst)" ]; then
		echo "Bottle has already been in bottles.lst, don't need to import'"
		exit 6
	else
		echo "$absolute1" >> $BOTTLES/bottles.lst
		echo "Imported bottle was added to bottles.lst"
	fi
else
	echo "Error: $1 is not a bottle"
	echo $USAGE
	exit 5
fi
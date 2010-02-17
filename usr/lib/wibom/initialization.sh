#!/usr/bin/env bash
# wibom script to create bottles directory, list and default bottle
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]

BOTTLES="$HOME/.local/share/bottles"

if ! [ "$(which wine)" ]; then
	echo "Fatal error: Wine not found."
	exit 127
fi

# Creating the bottles directory, if doesn't exist
if ! [ -d $BOTTLES ]; then
	mkdir -p $BOTTLES
	echo "Directory $BOTTLES was created"
fi

if ! ([ -e $BOTTLES/default/user.reg ] && [ -e $BOTTLES/default/system.reg ] && [ -d $BOTTLES/default/drive_c ]); then
	# Setting the default bottle directory and creating the default bottle
	export WINEPREFIX="$BOTTLES/default"
	wine you-wont-found-this 2>/dev/null # simple hack for creating a wine bottle in WINEPREFIX
	echo "The default bottle was created in $BOTTLES/default"
	# Setting back to default, if something bad happens
	export WINEPREFIX=""
fi

# Creating the list, if not existed
touch $BOTTLES/bottles.lst

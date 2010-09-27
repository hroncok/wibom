#!/usr/bin/env bash
# wibom script to download and execute wine_colors_from_gtk.py in a bottle or in all SHARE
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]
# wine_colors_from_gtk.py © Endolith (GPL)

USAGE="Usage: wibom colorize bottle_path/ALL"

SHARE="$HOME/.local/share"
BOTTLES="$SHARE/bottles"
SCRIPT="$SHARE/wine_colors_from_gtk/wine_colors_from_gtk.py"

# This is a way to determinate a path, where this script is
LIBDIR=`dirname "${0%}"`

get_script() {
	cd "$SHARE"
	wget http://gist.github.com/gists/74192/download -O wine-colors.tar.gz
	exitcode="$?" # Remember the exitcode now
	if [ $exitcode == 0 ]; then
		# Was downloaded, we can delete old version
		rm -rf wine_colors_from_gtk
		tar -zxf wine-colors.tar.gz
		mv gist* wine_colors_from_gtk
	fi
	rm wine-colors.tar.gz # Is there even if not downloaded
	# Maybe this is the firs time and we are offline
	if ! [ -d wine_colors_from_gtk ]; then
		echo "You are offline and the script was not downloaded before"
		exit 4
	fi
	cd - > /dev/null # Go back
}

if [ -z "$1" ]; then
	echo "$USAGE"
	exit 1
fi

if [ "$1" == "ALL" ]; then
	get_script
	# Colorize the default bottle
	$LIBDIR/runin.sh "$BOTTLES/default" python "$SCRIPT"
	# Colorize all others
	while read line
	do
		$LIBDIR/runin.sh "$line" python "$SCRIPT"
	done < "$BOTTLES/bottles.lst"
	exit 0
else
	if ! [ -d $1 ]; then
		echo "Error: $1 is not a directory"
		echo "$USAGE"
		exit 4
	fi

	absolute1=`cd "$1"; pwd` # We need absolute path (little hack)
	if [ -e "$1/user.reg" ] && [ -e "$1/system.reg" ] && [ -d "$1/drive_c" ]; then
		# We are in bottle
		get_script
		$LIBDIR/runin.sh "$absolute1" python "$SCRIPT"
		exit 0
	else
		echo "Error: $absolute1 is not a bottle"
		echo "$USAGE"
		exit 5
	fi
fi

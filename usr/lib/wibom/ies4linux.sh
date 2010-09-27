#!/usr/bin/env bash
# wibom script to download and ies4linux
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2009, Miro Hrončok [hroncok.cz]
# ies4linux © Sergio Luis Lopes Junior (GPL)

echo "Won't work"
exit 1

USAGE="Usage: wibom ies4linux"

SHARE="$HOME/.local/share"
export BOTTLES="$SHARE/bottles"
SCRIPT="$SHARE/ies4linux/ies4linux"

# This is a way to determinate a path, where this script is
LIBDIR=`dirname "${0%}"`

# Getting ies4linux
cd "$SHARE"
wget http://www.tatanka.com.br/ies4linux/downloads/ies4linux-latest.tar.gz
exitcode="$?" # Remember the exitcode now
if [ $exitcode == 0 ]; then
	# Was downloaded, we can delete old version
	rm -rf ies4linux
	tar -zxf ies4linux-latest.tar.gz
	rm ies4linux-latest.tar.gz
	mv ies4linux-* ies4linux
else
	rm ies4linux-latest.tar.gz # Is there even if not downloaded
fi

# Maybe this is the firs time and we are offline
if ! [ -d ies4linux ]; then
	echo "You are offline and the script was not downloaded before"
	exit 4
fi

cd - > /dev/null # Go back

# Run the script
$SCRIPT --basedir "$BOTTLES/ies"
exitcode="$?" # Remember the exitcode now
if [ $exitcode != 0 ]; then
	exit $exitcode
fi

# Import the bottles (try to import all of them)
for FILE in "$BOTTLES/ies/*"; do $LIBDIR/import.sh "$FILE"; done
exit 0

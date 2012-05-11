#!/bin/sh
#
# SliTaz Base functions used from boot scripts to end user tools. Use
# gettext and not echo for messages. Keep output suitable for GTK boxes
# and Ncurses dialog. LibTaz should not depend on any configuration file.
# No bloated code here, function must be used by at least 3-4 tools.
#
# Documentation: man libtaz or /usr/share/doc/slitaz/libtaz.txt
#
# Copyright (C) 2012 SliTaz GNU/Linux - BSD License
#

# Internationalization.
. /usr/bin/gettext.sh
TEXTDOMAIN='slitaz-base'
export TEXTDOMAIN

# Internal variables.
okmsg="$(gettext "Done")"
ermsg="$(gettext "Failed")"
okcolor=32
ercolor=31

# Parse cmdline options and store values in a variable.
for opt in "$@"
do
	case "$opt" in
		--*=*) export ${opt#--} ;;
		--*) export ${opt#--}="yes" ;;
	esac
done
[ "$HTTP_REFERER" ] && output="html"

# Return command status. Default to colored console output.
status() {
	local check=$?
	case $output in
		raw|gtk) 
			done=" $okmsg" 
			error=" $ermsg" ;;
		html)
			done=" <span class='done'>$okmsg</span>" 
			error=" <span class='error'>$ermsg</span>" ;;
		*)
			cols=$(stty -a -F /dev/tty | head -n 1 | cut -d ";" -f 3 | awk '{print $2}')
			local scol=$(($cols - 10))
			done="\\033[${scol}G[ \\033[1;${okcolor}m${okmsg}\\033[0;39m ]"
			error="\\033[${scol}G[ \\033[1;${ercolor}m${ermsg}\\033[0;39m ]" ;;
	esac
	if [ $check = 0 ]; then
		echo -e "$done"
	else
		echo -e "$error"
	fi
}

# Line separator.
separator() {
	local sepchar="="
	[ "$HTTP_REFERER" ] && local sepchar="<hr />"
	case $output in
		raw|gtk) local sepchar="-" && local cols="8" ;;
		html) local sepchar="<hr />" ;;
		*) local cols=$(stty -a -F /dev/tty | head -n 1 | cut -d ";" -f 3 | awk '{print $2}') ;;
	esac
	for c in $(seq 1 $cols); do
		echo -n "$sepchar"
	done && echo ""
}

# Display a bold message. GTK Yad: Works only in --text=""
boldify() {
	case $output in
		raw) echo "$@" ;;
		gtk) echo "<b>$@</b>" ;;
		html) echo "<strong>$@</strong>" ;;
		*) echo -e "\\033[1m$@\\033[0m" ;;
	esac
}

# Check if user is logged as root.
check_root() {
	if [ $(id -u) != 0 ]; then
		gettext "You must be root to execute:" && echo " $(basename $0) $@"
		exit 1
	fi
}
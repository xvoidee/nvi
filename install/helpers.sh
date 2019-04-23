#!/bin/bash

# Probes command in $PATH
#
# Status is in $?
#
# Parameters:
# - $1: command name
probe_command() {
	command -v $1 > /dev/null
}

# Set text color in terminal
# 
# Parameters:
# - $1: color code
set_text_color() {
	tput setaf $1
}

# Prints message in orange color
#
# Parameters:
# - $1: message
print_info() {
	set_text_color 3
	echo " [      ] $1"
	set_text_color 0
}

# Prints message in green color
#
# Parameters:
# - $1: message
print_success() {
	set_text_color 2
	echo " [  ok  ] $1"
	set_text_color 0
}

# Print message in red color
#
# Parameters:
# - $1: message
print_fail() {
	set_text_color 1
	echo " [ fail ] $1"
	set_text_color 0
}

probe_mkdir() {
	if [ -d $1 ] ; then
		print_fail "Unable to create directory $1, already exists"
		exit 1
	fi

	mkdir -p $1 > /dev/null
	if [[ $? -eq 1 ]] ; then
		print_fail "Unable to create directory $1"
		exit 1
	fi
}


# $1 target
# $2 website
# $3 archive to download
# $4 rename after extraction (optional)
download_and_extract() {
	# check if available in temp
	if [ ! -f temp/$3 ]; then
		wget -c $2/$3 -P temp/
	fi

	folder=`tar -tf temp/$3 | head -1 | cut -f1 -d"/"`
	rm -rf temp/$folder
	tar -xf temp/$3 -C temp/
	mv temp/$folder $1/$4
}

# $1 true to probe (=skip install)
# $2 pre-installed path
# $3 binary name
# $4 relative path
# $5 install directory
# $6 website to download
# $7 archive to download
# $8 rename extracted folder (optional)
probe_or_install() {
	if ( $1 ) ; then
		probe_binary $2 $3 $4
	else
		download_and_extract $5 $6 $7 $8
	fi
}


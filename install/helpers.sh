#!/bin/bash

# set text color in terminal
set_text_color() {
	tput setaf $1
}

# print orange message
print_info() {
	set_text_color 3
	echo $1
	set_text_color 0
}

# print green message
print_success() {
	set_text_color 2
	echo $1
	set_text_color 0
}

# print red message
print_fail() {
	set_text_color 1
	echo $1
	set_text_color 0
}

# check if command available
probe_command() {
	command -v $1 > /dev/null
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

# check if binary can be found in path/PATH
# returns true if binary is found
probe_binary() {
	preinstalled_path=$1
	binary_name=$2
	relative_path=$3

	c=$binary_name
	if [ ! -z $preinstalled_path ] ; then
		c=$preinstalled_path/$relative_path/$binary_name
	fi

	probe_command $c
	if [[ $? -eq 1 ]] ; then
		return 1
	fi

	return 0
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


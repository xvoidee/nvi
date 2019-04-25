#!/bin/bash

# Probes binary in:
# - $PATH
# - custom path if set
#
# Parameters:
# - $1: binary name
# - $2: preinstalled path
# - $3: optional subfolder (/bin for example)
#
# Return:
# - 0 on success
# - 1 on failure
#
# In case of fail:
# - sets errno to 1
probe_binary() {
	if [ -z $2 ] ; then
		__p="\$PATH"
		probe_command $1
	else
		__p=$2/$3
		PATH=$PATH:$2/$3 probe_command $1
	fi

	if [ $? -eq 0 ]; then
		print_success "probing $1 in $__p"
		unset __p
		return 0
	else
		print_fail "probing $1 in $__p"
		errno=1
		unset __p
		return 1
	fi
}

# Probes command in:
# - $PATH
#
# Status is in:
# - $?
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

# Probe mkdir command
#
# Parameters:
# - $1: directory name
#
# Status is in:
# - $?
#
# In case of fail:
# - sets errno to 1
probe_mkdir() {
	print_info "directory $1 is being created"

	if [ -d $1 ] ; then
		print_fail "directory $1 exists"
		errno=1
		return 1
	fi

	mkdir -p $1 > /dev/null
	if [[ $? -eq 1 ]] ; then
		print_fail "directory $1 cannot be created"
		errno=1
		return 1
	fi

	print_success "directory $1 created"
	return 0
}

# Downloads and extracts archive
#
# Parameters:
# - $1: target path
# - $2: website
# - $3: archive to download
# - $4: rename after extraction (optional)
download_and_extract() {
	mkdir -p "./temp"

	# check if available in temp
	print_info "$3 is in ./temp"
	if [ ! -f temp/$3 ] ; then
		print_info "$3 is being downloaded"
#		wget -c $2/$3 -P temp/
		cp ~/temp/$3 temp/

		if [ ! -f temp/$3 ] ; then
			print_fail "$3 was not downloaded"
			return 1
		else
			print_success "$3 downloaded"
		fi
	fi

	folder=`tar -tf temp/$3 | head -1 | cut -f1 -d"/"`
	rm -rf temp/$folder
	tar -xf temp/$3 -C temp/
	mv temp/$folder $1/$4
	sleep 1
}

# Installs dependency
#
# Parameters:
# - $1: numan readable dependency name
# - $2: install path
# - $3: website for download
# - $4: archive to download
# - $5: rename after install (optional)
#
# In case of fail:
# - sets errno to 1
install() {
	print_info "$1 is being installed"
	
	download_and_extract $2 $3 $4 $5
	if [ $? -eq 1 ] ; then
		print_fail "$1 was not installed"
		errno=1
	fi

	print_success "$1 installed"
}


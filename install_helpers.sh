#!/bin/bash

# $1 - text
# $2 - color
print() {
	tput setaf $2
	echo "$1"
	tput init
}

# $1 - text
print_info() {
	print "$1" 3
}

# $1 - text
print_success() {
	print "$1" 2
}

# $1 - text
print_fail() {
	print "$1" 1
}

# $1 - binary name
# $2 - receives true if failed
probe_executable_exists() {
	print_info "  $1"
	command -v $1 > /dev/null
	if [ $? -eq 0 ] ; then
		print_success "  $1 exists"
		return 1
	fi
	eval "$2=true"
	print_fail "  $1 not exists"
	return 0
}

# $1 - binary name
# $2 - receives true if failed
probe_executable_not_exists() {
	print_info "  $1"
	command -v $1 > /dev/null
	if [ $? -eq 1 ] ; then
		print_success "  $1 not exists"
		return 1
	fi
	eval "$2=true"
	print_fail "  $1 exists"
	return 0
}

# $1 - file
# $2 - receives true if failed
probe_file_not_exists() {
	print_info "  $1"
	if [ ! -f $1 ] ; then
		print_success "  $1 not exists"
		return 1
	fi
	eval "$2=true"
	print_fail "  $1 exists"
	return 0
}

# $1 - path
# $2 - receives true if failed
probe_dir_not_exists() {
	print_info "  $1"
	if [ ! -d $1 ] ; then
		print_success "  $1 not exists"
		return 1
	fi
	eval "$2=true"
	print_fail "  $1 exists"
	return 0
}

# $1 - path
# $2 - receives true if failed
probe_dir_exists() {
	print_info "  $1"
	if [ -d $1 ] ; then
		print_success "  $1 exists"
		return 1
	fi
	eval "$2=true"
	print_fail "  $1 not exists"
	return 0
}

# $1 - pip3 package name
# $2 - receives true if not found
# $3 - human friendly name
probe_pip3_package() {
	print_info "  $3"
	pip3 list | grep $1 > /dev/null
	if [ $? -eq 1 ] ; then
		print_fail "  $3"
		eval "$2=true"
		return 1
	fi
	print_success "  $3"
	return 0
}

# $1 - path
# $2 - receives true if not created
probe_mkdir() {
	print_info "  $1"
	mkdir -p $1
	if [ $? -eq 1 ] ; then
		print_fail "  $1"
		eval "$2=true"
		return 1
	fi

	print_success "  $1"
	return 0
}

# $1 - website
# $2 - archive to download
# $3 - receives true if failed
download() {
	mkdir -p temp
	print_info "  $2"
	wget -c $1/$2 -P temp/

	if [ ! -f temp/$2 ] ; then
		print_fail "  $2 was not downloaded"
		eval "$2=true"
		return 1
	fi

	print_success "  $2"
	return 0
}

# $1 - archive
# $2 - target directory
extract() {
	print_info "  $1"
	tar -xf temp/$1 -C $2/
	print_success "  $1"
}

# $1 - version
# $2 - receives true if succeeded
# $3 - receives version
probe_lsb_version() {
	lsb_release -r | grep "$1"
	if [ $? -eq 0 ] ; then
		eval "$2=true"
		eval "$3=$1"
		return 0
	fi
	return 1
}


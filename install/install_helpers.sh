#!/bin/bash

# $1 - text
# $2 - color
print() {
	tput setaf $2
	echo "$1"
	tput sgr0
}

# $1 - text
print_info() {
	print "[      ] $1" 3
}

# $1 - text
print_success() {
	print "[  OK  ] $1" 2
}

# $1 - text
print_fail() {
	print "[ FAIL ] $1" 1
}

# $1 - path
# $2 - receives false if directory not exists, otherwise not changed
check_directory_not_exists() {
	print_info "Check for directory $1"
	if [ ! -d $1 ] ; then
		print_success "Check for directory $1 - not exists, we'll create it"
		return 1
	fi
	eval "$2=false"
	print_fail "Check for directory $1 - exists"
	return 0
}

# $1 - path
# $2 - receives false if not created, otherwise not changed
probe_mkdir() {
	print_info "Create directory $1"
	mkdir -p $1
	if [ $? -eq 1 ] ; then
		print_fail "Create directory $1"
		eval "$2=false"
		return 1
	fi

	print_success "Create directory $1"
	return 0
}

# $1 - website
# $2 - archive to download
# $3 - receives false if failed, otherwise not changed
download() {
	mkdir -p temp
	print_info "Download $2 from $1"
	wget -4 -c $1/$2 -P temp/

	if [ ! -f temp/$2 ] ; then
		print_fail "Download $2 - was not downloaded, try yourself:"
		print_info "wget -c $1/$2 -P temp/"
		eval "$2=false"
		return 1
	fi

	print_success "Download $2"
	return 0
}

# $1 - archive
# $2 - target directory
extract() {
	print_info "Extract $1 to $2"
	tar -xf $1 -C $2/
	print_success "Extract $1"
}

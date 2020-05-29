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

# $1 - binary name
# $2 - receives false if executable not exists, otherwise not changed
check_executable_exists() {
	print_info "Check for $1 executable"
	command -v $1 > /dev/null
	if [ $? -eq 0 ] ; then
		print_success "Check for $1 executable - available through \$PATH"
		return 1
	fi
	eval "$2=false"
	print_fail "Check for $1 executable - not available through \$PATH"
	return 0
}

# $1 - binary name
# $2 - receives false if executable exists, otherwise not changed
check_executable_not_exists() {
	print_info "Check executable $1"
	command -v $1 > /dev/null
	echo $?
	alias
	echo $SHELL
	command -v $1 > /dev/null
	if [ $? -eq 1 ] ; then
		print_success "Check executable $1 - not available through \$PATH"
		return 1
	fi
	eval "$2=false"
	print_fail "Check executable $1 - available through \$PATH"
	return 0
}

# $1 - pip3 package name
# $2 - receives false if pip3 package not found, otherwise not changed
# $3 - pretty print name
check_pip3_package_exists() {
	print_info "Check for pip3 package $3"
	pip3 --disable-pip-version-check list | grep $1 > /dev/null
	if [ $? -eq 1 ] ; then
		print_fail "Check for pip3 package $3 - not available, missing dependencies?"
		eval "$2=false"
		return 1
	fi
	print_success "Check for pip3 package $3 - available"
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
	wget -c $1/$2 -P temp/

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

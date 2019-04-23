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

# Probes node executable in:
# - $PATH
# - $nodejs_path if set
#
# Parameters:
# - $1: preinstalled path
# - $2: optional subfolder (/bin for example)
#
# Return:
# - 0 on success
# - 1 on failure
probe_nodejs() {
	if [ -z $1 ] ; then
		__p="\$PATH"
		probe_command "node"
	else
		__p="$1/$2"
		PATH=$PATH:$1/$2 probe_command "node"
	fi

	if [ $? -eq 0 ]; then
		print_success "probing node in $__p"
		unset __p
		return 0
	else
		print_fail "probing node in $__p"
		unset __p
		return 1
	fi
}

install_nodejs() {

}

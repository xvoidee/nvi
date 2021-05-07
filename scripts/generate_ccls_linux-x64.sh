#!/bin/bash

source $(dirname $0)/../install/helpers.sh

if [ -f ".ccls" ]; then
	print_fail ".ccls already exists!"
	exit 0
fi

if [ -z "$1" ]; then
	print_fail "Provide C++ compiler command as parameter"
	print_fail ".ccls file will not be generated"
	exit 0
fi

$1 > /dev/null 2>&1

if [ ! $? -eq 1 ]; then
	print_fail "Unable to use '$1' as a C++ compiler"
	exit 0
fi

echo "%compile_commands.json" > .ccls
$1 -Wp,-v -x c++ - -fsyntax-only < /dev/null 2>&1 | sed -n '/#include <...>/,/End/p' | egrep -v '#include|End' | sed 's/ \//-I\//g' | sed 's/ (framework directory)//g' >> .ccls

print_success ".ccls generated"

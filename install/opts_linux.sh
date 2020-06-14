#!/bin/bash

opts=`/usr/bin/getopt -o '' --long help,install-path:,install-alias:,install-alias-to: -- "$@"`

if [ $? != 0 ] ; then
	echo "getopt failed"
	print_help
	exit 1
fi

eval set -- "$opts"
while true ; do
	case "$1" in
		--help)
			print_help
			exit 0
			;;
		--install-path)
			install_path=$2
			shift
			shift
			;;
		--install-alias)
			install_alias=$2
			shift
			shift
			;;
		--install-alias-to)
			install_alias_to=$2
			shift
			shift
			;;
		--)
			shift
			break
			;;
		*)
			echo "unknown error"
			exit 1
			;;
	esac
done


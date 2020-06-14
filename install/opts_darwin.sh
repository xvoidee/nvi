#!/bin/bash

optspec=":hv-:"

while getopts "$optspec" optchar; do
	case "${optchar}" in
		-)
			case "${OPTARG}" in
				help)
					print_help
					exit 0
					;;
				install-path=*)
					install_path=${OPTARG#*=}
					;;
				install-alias=*)
					install_alias=${OPTARG#*=}
					;;
				install-alias-to=*)
					install_alias_to=${OPTARG#*=}
					;;
				*)
					echo "unknown option --${OPTARG}"
					exit 0
					;;
			esac;;
		*)
			echo "unknown option -${OPTARG}"
			;;
	esac
done


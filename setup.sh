#!/usr/bin/env bash

# exit on error
# http://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
abort() {
    echo >&2 'Abort'
    echo "An error occurred. Exiting" >&2
    exit 1
}

trap 'abort' 0

set -e

# Determine absolute path of script if needed
if [[ ! -d "${ABS_PATH}" ]]; then
	ABS_PATH="${BASH_SOURCE[0]}"
	if [ -h "${ABS_PATH}" ]; then
	  while [ -h "${ABS_PATH}" ]; do
	    ABS_PATH=`readlink "${ABS_PATH}"`
	  done
	fi
	pushd . > /dev/null
	cd `dirname ${ABS_PATH}` > /dev/null
	ABS_PATH=`pwd`;
	popd  > /dev/null
fi

PACKAGES_FOLDER="${HOME}/.config/sublime-text-3/Packages"
LINK_TARGET="${PACKAGES_FOLDER}/User"

# Create needed folders
mkdir -p "${ABS_PATH}/User"
mkdir -p "${ABS_PATH}/backup"
mkdir -p "${PACKAGES_FOLDER}"

# Start
echo '
Starting setup
'

[[ ! -d "${PACKAGES_FOLDER}" ]] && echo "Error: '${PACKAGES_FOLDER}' is not a valid folder" && exit 1

if [[ -d "${LINK_TARGET}" ]]; then
	if [[ ! -L "${LINK_TARGET}" ]]; then
		# Create backup
		echo "Directory '${LINK_TARGET}' already exists. Backing it up as '${ABS_PATH}/backup/User'"

		[[ -d "${ABS_PATH}/backup/User" ]] && rm -rf "${ABS_PATH}/backup/User"

		cp -r "${LINK_TARGET}" "${ABS_PATH}/backup/User"
	fi

	rm -rf "${LINK_TARGET}"
fi

echo "
LINKING: '${ABS_PATH}/User' => '${LINK_TARGET}'"

ln -s "${ABS_PATH}/User" "${LINK_TARGET}"

trap : 0

echo >&2 '
Setup completed
'
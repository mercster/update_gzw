#!/bin/bash

# Credit to @Wifiik_CZ on GZW Discord.

set -euo pipefail

# find steamcmd
_detect_steamcmd() {
	for cmd in "${HOME}/steamcmd/steamcmd.sh" $(command -v steamcmd.sh) $(command -v steamcmd); do
		if [ -x "$cmd" ]
		then
			echo "$cmd"
			break
		fi
	done
}

# steamcmd install wrapper
_install_steamcmd() {
	mkdir -p ${HOME}/steamcmd
	if command -v curl &> /dev/null
	then
		fetch='curl -sSLo-'
	else
		fetch='wget -qO-'
	fi
	$fetch 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' 2>/dev/null \
		| tar -C ${HOME}/steamcmd -xzf -
	echo "steamcmd installed for you in ${HOME}/steamcmd - but you should be a nice linux user and install one properly using a package manager!" >&2
}

# make sure we have steamcmd
STEAMCMD=$(_detect_steamcmd)
if [ -z "${STEAMCMD}" ]; then
	_install_steamcmd
	STEAMCMD=${HOME}/steamcmd/steamcmd.sh
fi

# find steam dir
STEAM_DIR=$(dirname $(find ${HOME}/.local/share -type d -name steamapps 2>/dev/null | head -n 1))
STEAM_USERNAME=""
REVERT=false

# read command line options
while getopts "d:u:hr" opt
do
	case ${opt} in
		u)
			STEAM_USERNAME=${OPTARG}
			;;
		d)
			STEAM_DIR=${OPTARG}
			;;
		r)
			REVERT=true
			;;
		h)
			echo "Usage: $0 [-d <steam_dir>] [-u <steam_username>] [-r]" >&2
			exit 0
			;;
		\?)
			echo "Usage: $0 [-d <steam_dir>] [-u <steam_username>] [-r]" >&2
			echo "Invalid option: -${OPTARG}" >&2
			exit 1
			;;
	esac
done

GAME_DIR="steamapps/common/Gray Zone Warfare"

if [ -z "${STEAM_DIR}" ]
then
	echo "Steam directory not found. Change Steam directory with -d option." >&2
	exit 1
fi

if [ ! -d "${STEAM_DIR}/${GAME_DIR}" ]
then
	echo "Game directory ${STEAM_DIR}/${GAME_DIR} not found. Change Steam directory with -d option." >&2
	exit 1
fi

declare -a FILES=(
	${STEAM_DIR}/${GAME_DIR}/GZW/Content/SKALLA/PrebuildWorldData/World/cache/0xaf497c273f87b6e4_0x7a22fc105639587d.dat
	${STEAM_DIR}/${GAME_DIR}/GZW/Content/SKALLA/PrebuildWorldData/World/cache/0xb9af63cee2e43b6c_0x3cb3b3354fb31606.dat
)

if [ ! -f "${FILES[0]}" ]
then
	echo "Game files not found. Something is very wrong!" >&2
	exit 1
fi

if ! ${REVERT}
then
	if [ -z "${STEAM_USERNAME}" ]
	then
		read -p "Steam username: " STEAM_USERNAME
	fi
	read -s -p "Steam password: " STEAM_PASSWORD
fi

# Apply the update & fix
chmod 0755 ${FILES[@]}
echo "Mode of ${FILES[*]} changed to 0755 (vanilla config)"

if ! ${REVERT}
then
	echo "Updating game files..."
	$STEAMCMD \
		+force_install_dir "${STEAM_DIR}" \
		+login "${STEAM_USERNAME} ${STEAM_PASSWORD}" \
		+app_update 2479810 \
		+quit
	echo "Game files updated!"
	chmod 0444 ${FILES[@]}
	echo "Mode of ${FILES[*]} changed to 0444 (world read-only)"
fi

echo "Done! Happy gaming!"

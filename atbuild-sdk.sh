#!/bin/bash

# Usage:
# 	1. Build SDK from latest repositories
#	$ source ./atbuild-sdk.sh --build-sdk
#
#	2. Compile a local repository and install libraries, headers and executables into SDK which is used for local code change testing
#	$ source ./atbuild.sh --local-install <path-to-sdk-to-install-local-libraries>
#
#
# Note that: for convenient usage, you can alias "source <path-to-atbuild-sdk-script>/atbuild.sh" to something like "autobuild"



SDK_BASE_PATH=/home/${USER}/workspace/sdk
SDK_TMP_PATH=${SDK_BASE_PATH}/tmp

ORIGINAL_DIR=$(pwd)

LATEST_REMOTE_MASTER_COMMIT_ID="dummy111"
LATEST_LOCAL_MASTER_COMMIT_ID="dummy222"


# Usage: retrieve_repo "repo_name" "user_name"
# Example: retrieve_repo "itc-framework" "giang-nguyentbk"
retrieve_repo()
{
	echo
	echo "#################################"
	LATEST_REMOTE_MASTER_COMMIT_ID="dummy111"
	LATEST_LOCAL_MASTER_COMMIT_ID="dummy222"

	if [ -d "${SDK_TMP_PATH}/$1/.git" ]; then
		echo "Repository $1 already exists!"
		cd ${SDK_TMP_PATH}/$1
		LATEST_REMOTE_MASTER_COMMIT_ID="$(git ls-remote --heads https://github.com/$2/$1.git | grep -E "refs/heads/master" | awk 'NR==1{print $1}')"
		LATEST_LOCAL_MASTER_COMMIT_ID="$(git rev-list master --first-parent | awk 'NR==1{print $1}')"
		echo "LATEST_REMOTE_MASTER_COMMIT_ID=$LATEST_REMOTE_MASTER_COMMIT_ID"
		echo "LATEST_LOCAL_MASTER_COMMIT_ID=$LATEST_LOCAL_MASTER_COMMIT_ID"
	else
		cd ${SDK_TMP_PATH}
		git clone https://github.com/$2/$1.git
		LATEST_LOCAL_MASTER_COMMIT_ID="dummy111"
	fi

	cd ${SDK_TMP_PATH}/$1
	if [ "$LATEST_REMOTE_MASTER_COMMIT_ID" == "$LATEST_LOCAL_MASTER_COMMIT_ID" ]; then
		echo "Repository $1 already up-to-date!"
	else
		# Discard untracked files in working directory
		git clean -xfd
		# Discard an un-pushed commit in local repository and unstaged changes in working directory
		git reset --hard HEAD~1
		# Pull rebase to make git log history linear
		git pull --rebase
	fi

	
}

# Usage: compile_repo "repo_name"
# Example: compile_repo "itc-framework"
compile_repo()
{
	## Compile
	cd ${SDK_TMP_PATH}/$1/sw/make
	make clean
	make
	if [ -d "${SDK_TMP_PATH}/$1/sw/bin/lib" ]; then
		echo "Copying libraries into SDK..."
		mv ${SDK_TMP_PATH}/$1/sw/bin/lib/* ${NEW_SDK_SYSROOT_PATH}/usr/lib
	fi

	if [ -d "${SDK_TMP_PATH}/$1/sw/bin/include" ]; then
		echo "Copying header files into SDK..."
		mv ${SDK_TMP_PATH}/$1/sw/bin/include/* ${NEW_SDK_SYSROOT_PATH}/usr/include
	fi

	if [ -d "${SDK_TMP_PATH}/$1/sw/bin/exec" ]; then
		echo "Copying executables into SDK..."
		mv ${SDK_TMP_PATH}/$1/sw/bin/exec/* ${NEW_SDK_SYSROOT_PATH}/usr/exec
	fi
}

# Usage: compile_repo
# Example: compile_repo
copy_scripts_to_sdk()
{
	# Copy necessary scripts into the new SDK
	echo
	cp -rf ${SDK_TMP_PATH}/shellscripts/env.sh ${NEW_SDK_SYSROOT_PATH}
	cp -rf ${SDK_TMP_PATH}/shellscripts/unenv.sh ${NEW_SDK_SYSROOT_PATH}
	cd ${NEW_SDK_SYSROOT_PATH}
	source ./env.sh
}

do_build_sdk()
{
	echo
	echo "Start building SDK for target $(uname -r)..."

	# Define variables
	SDK_FOLDER_NAME="SDK-$(uname -r)-$(date +%Y%m%d%H%M%S%N)"
	NEW_SDK_PATH=${SDK_BASE_PATH}/${SDK_FOLDER_NAME}
	NEW_SDK_SYSROOT_PATH=${NEW_SDK_PATH}/sysroot

	# Remove old SDK
	rm -rf /home/${USER}/workspace/sdk/SDK-*

	# Prepare sdk folder
	mkdir -p ${SDK_TMP_PATH}
	mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/lib
	mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/include
	mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/exec

	retrieve_repo shellscripts giang-nguyentbk
	copy_scripts_to_sdk

	retrieve_repo common-utils giang-nguyentbk
	compile_repo common-utils

	retrieve_repo itc-framework giang-nguyentbk
	compile_repo itc-framework

	retrieve_repo utils-framework giang-nguyentbk
	compile_repo utils-framework

	retrieve_repo cli-daemon giang-nguyentbk
	compile_repo cli-daemon

	echo
	echo "#################################"
	echo
	echo "SDK built successfully can be found at $NEW_SDK_PATH [OK]"
}

do_local_install()
{
	echo "Start compiling and installing local repository..."

	if [ "x$1" == "x" ]; then
		echo "Missing path to SDK in order to install local libraries!"
		return -1
	fi

	echo "Target SDK location: $1"
	
	if [ -d "${ORIGINAL_DIR}/sw/make" ]; then
		cd ${ORIGINAL_DIR}/sw/make
		make clean
		make

		if [ -d "${ORIGINAL_DIR}/sw/bin/lib" ]; then
			echo "Copying libraries into SDK..."
			mv ${ORIGINAL_DIR}/sw/bin/lib/* $1/sysroot/usr/lib
		fi

		if [ -d "${ORIGINAL_DIR}/sw/bin/include" ]; then
			echo "Copying header files into SDK..."
			mv ${ORIGINAL_DIR}/sw/bin/include/* $1/sysroot/usr/include
		fi

		if [ -d "${ORIGINAL_DIR}/sw/bin/exec" ]; then
			echo "Copying executables into SDK..."
			mv ${ORIGINAL_DIR}/sw/bin/exec/* $1/sysroot/usr/exec
		fi

		echo
		echo "#################################"
		echo
		echo "Compiled local libraries successfully! [OK]"
		echo "Installed local libraries into SDK successfully! [OK]"
	else
		echo "Script atbuild-sdk.sh was not running in any repository directory!"
	fi
}

do_print_usage()
{
	# Display Help
	echo "Usage: atbuild-sdk.sh"
	echo "Syntax: source ./atbuild-sdk.sh [ --build-sdk | "
	echo "                                  --local-install <path-to-SDK-to-install-local-libraries> ]"
	echo "Options:"
	echo "--build-sdk		Pull latest repositories if necessary, compile and install its utility scripts, headers, libraries and executables."
	echo "--local-install		Compile your local repository, install headers, libraries and executables into given SDK in the 2nd argument."
	echo "               		If SDK is already built, but env variable SDKSYSROOT not exported yet (new bash shell), manually \"source <path-to-SDK>/env.sh\"."
	echo "               		Remember running this command in your local repo directory!"
	echo "-h, --help		Print the usage and detailed description."
	echo
	echo "Pro hints:"
	echo "1. Try aliasing \"source <path-to-atbuild-sdk-script>/atbuild.sh\" to something like \"atbuild.sh\"!"
}

# Main point
# Parsing arguments
while :
do
	case $1 in
		--build-sdk)
			do_build_sdk
			shift 1
			;;

		--local-install)
			do_local_install $2
			shift 2
			;;

		-h | --help)
			do_print_usage
			shift 1
			;;

		# Any options without spaces in the middle
		*[!\ ]*)
			echo "Error: Unknown option: \"$1\""
			do_print_usage
			break
			;;
		*)
			break
			;;
	esac
done



# Back to original folder
cd ${ORIGINAL_DIR}
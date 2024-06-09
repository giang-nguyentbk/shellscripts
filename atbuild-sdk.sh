#!/bin/bash

SDK_FOLDER_NAME="SDK-$(uname -r)-$(date +%Y%m%d%H%M%S%N)"

SDK_BASE_PATH=/home/${USER}/workspace/sdk
NEW_SDK_PATH=${SDK_BASE_PATH}/${SDK_FOLDER_NAME}
SDK_TMP_PATH=${SDK_BASE_PATH}/tmp
NEW_SDK_SYSROOT_PATH=${NEW_SDK_PATH}/sysroot

ORIGINAL_DIR=$(pwd) 

rm -rf /home/${USER}/workspace/sdk/SDK-*

# Prepare sdk folder
mkdir -p ${SDK_TMP_PATH}
mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/lib
mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/include
mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/exec

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
		# Discard unstaged files in working directory
		git restore .
		# Discard an un-pushed commit in local repository
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
	mv ${SDK_TMP_PATH}/$1/sw/bin/lib/* ${NEW_SDK_SYSROOT_PATH}/usr/lib
	mv ${SDK_TMP_PATH}/$1/sw/bin/include/*.h ${NEW_SDK_SYSROOT_PATH}/usr/include

	if [ -d "${SDK_TMP_PATH}/$1/sw/bin/exec" ]; then
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


# Main point
echo
echo "Start building SDK for target $(uname -r)..."

retrieve_repo shellscripts giang-nguyentbk
copy_scripts_to_sdk

retrieve_repo common-utils giang-nguyentbk
compile_repo common-utils

retrieve_repo itc-framework giang-nguyentbk
compile_repo itc-framework

retrieve_repo utils-framework giang-nguyentbk
compile_repo itc-framework

echo
echo "#################################"
echo
echo "SDK built successfully can be found at $NEW_SDK_PATH [OK]"

# Back to original folder
cd ${ORIGINAL_DIR}
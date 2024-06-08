#!/bin/bash

SDK_FOLDER_NAME="SDK-$(uname -r)-$(date +%Y%m%d%H%M%S%N)"

SDK_BASE_PATH=/home/${USER}/workspace/sdk
NEW_SDK_PATH=${SDK_BASE_PATH}/${SDK_FOLDER_NAME}
SDK_TMP_PATH=${SDK_BASE_PATH}/tmp
NEW_SDK_SYSROOT_PATH=${NEW_SDK_PATH}/sysroot

ORIGINAL_DIR=$(pwd) 

rm -rf /home/${USER}/workspace/sdk/*

# Prepare sdk folder
mkdir -p ${SDK_TMP_PATH}
mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/lib
mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/include
mkdir -p ${NEW_SDK_SYSROOT_PATH}/usr/exec

# Clone necessary repos
cd ${SDK_TMP_PATH}
git clone https://github.com/giang-nguyentbk/shellscripts.git
git clone https://github.com/giang-nguyentbk/common-utils.git
git clone https://github.com/giang-nguyentbk/itc-framework.git
git clone https://github.com/giang-nguyentbk/utils-framework.git

# Copy necessary scripts into the new SDK
cd ${SDK_TMP_PATH}/shellscripts
cp -rf ${SDK_TMP_PATH}/shellscripts/env.sh ${NEW_SDK_SYSROOT_PATH}
cp -rf ${SDK_TMP_PATH}/shellscripts/unenv.sh ${NEW_SDK_SYSROOT_PATH}
cd ${NEW_SDK_SYSROOT_PATH}
source ./env.sh

# Must build single libraries which do not depend on any other libraries
## Repo common-utils
cd ${SDK_TMP_PATH}/common-utils
cd ./sw/make
make clean
make
mv ${SDK_TMP_PATH}/common-utils/sw/bin/lib/* ${NEW_SDK_SYSROOT_PATH}/usr/lib
mv ${SDK_TMP_PATH}/common-utils/sw/bin/include/*.h ${NEW_SDK_SYSROOT_PATH}/usr/include

## Repo itc-framework
cd ${SDK_TMP_PATH}/itc-framework
cd ./sw/make
make clean
make
mv ${SDK_TMP_PATH}/itc-framework/sw/bin/lib/* ${NEW_SDK_SYSROOT_PATH}/usr/lib
mv ${SDK_TMP_PATH}/itc-framework/sw/bin/include/*.h ${NEW_SDK_SYSROOT_PATH}/usr/include
mv ${SDK_TMP_PATH}/itc-framework/sw/bin/exec/* ${NEW_SDK_SYSROOT_PATH}/usr/exec

## Repo utils-framework
cd ${SDK_TMP_PATH}/utils-framework
cd ./sw/make
make clean
make
mv ${SDK_TMP_PATH}/utils-framework/sw/bin/lib/* ${NEW_SDK_SYSROOT_PATH}/usr/lib
mv ${SDK_TMP_PATH}/utils-framework/sw/bin/include/*.h ${NEW_SDK_SYSROOT_PATH}/usr/include

# Clean tmp/ folder
rm -rf /home/${USER}/workspace/sdk/tmp

# Back to original folder
cd ${ORIGINAL_DIR}
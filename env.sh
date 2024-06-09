#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# echo $SCRIPTPATH

echo "Exporting  SDKSYSROOT=$SCRIPTPATH"
export SDKSYSROOT="$SCRIPTPATH"

echo "Exporting  LD_LIBRARY_PATH=$SDKSYSROOT/usr/lib:\$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$SDKSYSROOT/usr/lib:$LD_LIBRARY_PATH"


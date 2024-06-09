#!/bin/bash

SCRIPTPATH="$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)"
# echo $SCRIPTPATH

echo "Exporting  SDKSYSROOT=$SCRIPTPATH"
export SDKSYSROOT="$SCRIPTPATH"

# Used for restore original LD_LIBRARY_PATH purpose
echo "Exporting  ORIGINAL_LD_LIBRARY_PATH=$LD_LIBRARY_PATH (to be restored)"
export ORIGINAL_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"

echo "Exporting  LD_LIBRARY_PATH=$SDKSYSROOT/usr/lib:\$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$SDKSYSROOT/usr/lib:$LD_LIBRARY_PATH"


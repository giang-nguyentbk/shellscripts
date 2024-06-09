#!/bin/bash

SCRIPTPATH="$(readlink -f ${BASH_SOURCE[0]} | xargs dirname)"
echo $SCRIPTPATH

echo "Exporting  SDKSYSROOT=$SCRIPTPATH"
export SDKSYSROOT="$SCRIPTPATH"

echo "Exporting  LD_LIBRARY_PATH=$SDKSYSROOT/usr/lib:\$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$SDKSYSROOT/usr/lib:$LD_LIBRARY_PATH"


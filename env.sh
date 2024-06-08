#!/bin/bash
echo "Exporting  SDKSYSROOT=$(pwd)"
export SDKSYSROOT="$(pwd)"

echo "Exporting  LD_LIBRARY_PATH=$SDKSYSROOT/usr/lib:\$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$SDKSYSROOT/usr/lib:$LD_LIBRARY_PATH"


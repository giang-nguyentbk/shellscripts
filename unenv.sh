#!/bin/bash

echo "Deleting  LD_LIBRARY_PATH"
export -n LD_LIBRARY_PATH

echo "Deleting  SDKSYSROOT=$SDKSYSROOT"
export -n SDKSYSROOT

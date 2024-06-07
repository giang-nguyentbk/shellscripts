#!/bin/bash

# what is an SDK?
#  SDK consists all of necessary things needed for running programs in a specific target device, including:
#	+ Header files related to libraries: sdk/sysroot/usr/include, include headers of:
#		- Standard libraries or external 3rd party libraries like libstdc++, libgcc, zlib,...
#		- All own built static and dynamic libraries.
#	+ Static and dynamic shared libraries.
#	+ Utility scripts: sdk/sysroot/scripts, which is used to:
#		- Setup environment like set env variables, set LD_LIBRARY_PATH, set SYSROOTSDK, do some preparation,...
#		- Do some utilities like generating binary database,...
#	+ Common executable files: sdk/sysroot/usr/bin, which needs to run along with every main executable programs.
#	+ Text file databases: sdk/sysroot/usr/db
#	+ Consider as a rootfs: sdk/sysroot/

# This is a script that automatically does:
# 	+ Clone latest-master-branch repositories.
#	+ Move (cd) into each repo.
#	+ Compile necessary static or dynamic shared libraries.
#	+ Move libraries to a common sdk folder.


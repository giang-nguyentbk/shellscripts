# shellscripts

## atbuild-sdk.sh
**what is an SDK?**
```
SDK consists all of necessary things needed for running programs in a specific target device, including:
	+ Header files related to libraries: sdk/sysroot/usr/include, include headers of:

		- Standard libraries or external 3rd party libraries like libstdc++, libgcc, zlib,...

		- All own built static and dynamic libraries.

	+ Static and dynamic shared libraries.

	+ Utility scripts: sdk/sysroot/scripts, which is used to:
		- Setup environment (env.sh) like set env variables, set LD_LIBRARY_PATH, set SYSROOTSDK, do some preparation,...

		- Do some utilities like generating binary database,...

	+ Common executable files: sdk/sysroot/usr/bin, which needs to run along with every main executable programs.

	+ Text file databases: sdk/sysroot/usr/db

	+ Consider as a rootfs: sdk/sysroot/

This is a script that automatically does:
 	+ Clone latest-master-branch repositories.

	+ Move (cd) into each repo.

	+ Compile necessary static or dynamic shared libraries.

	+ Move libraries to a common sdk folder.
```

```bash
# Usage
$ source ./atbuild-sdk.sh
```

![](./assets/atbuild-sdk.png?raw=true)

![](./assets/atbuild-sdk-1.png?raw=true)

![](./assets/atbuild-sdk-local-install.png?raw=true)

![](./assets/atbuild-sdk-folder.png?raw=true)

![](./assets/atbuild-sdk-tree.png?raw=true)

![](./assets/atbuild-sdk-help.png?raw=true)

# listdirsize.sh
```
Run this script in bash shell in order to list all folders size in your current directory.

Regarding file size we can simply use "ls -a"
```

![](./assets/listdirsize.png?raw=true)
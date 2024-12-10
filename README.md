# About this repo

This repository is modified based on the release version of OpenZFS 2.1. This is part of MLEC (Multi-level Erasure Coding) project that aims to implement MLEC in a real system. In the end, we hope to build HDFS on top of OpenZFS, with MLEC implemented.

# Initial Installation

First, reserve a node from Chameleon following this [guide](https://chameleoncloud.readthedocs.io/en/latest/technical/reservations.html), and launch an [instances](https://chameleoncloud.readthedocs.io/en/latest/technical/baremetal.html). The installation generally works for Ubuntu 20.04 and 22.04.

Then, clone the repository, and switch to the branch with MLEC implementation. 
```
git clone https://github.com/zhynwng/zfs-MLEC.git
git checkout zfs-2.1-myraid
```

Run the initialization script, which will install all necessary packages and set up the environment. Press Y for all options during package installation.
```
cd zfs-MLEC
./zfs_init.sh
```

Then reboot the machine. Make sure all changes are saved before you reboot. 
```
sudo reboot
```

After the reboot, you can run the full installation script. This script will set up system configuration to build ZFS from source.
```
./zfs_full_install.sh
```

You can see whether zfs is successfully installed by trying the command "zfs list". This the expected result:
```
cc@node2:~/zfs-MLEC$ zfs list
no datasets available
```

# Later install and uninstall

After the first installation, you can using the more light-weight installation script. This script omits some of the steps to make the build process faster
```
./zfs_install.sh
```

You can remove ZFS from the system by the following script
```
zfs_uninstall.sh
```

There are also testing scripts to test the general functionality of ZFS erasure coding systems (one is for general repair test, the other is to test the new easyscrub method). Feel free to explore and change these two scripts
```
./zfs_test.sh
./scrub_tesh.sh
```
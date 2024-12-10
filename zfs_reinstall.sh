#!/bin/bash

size=$1

# A simple shell script that uninstall zfs 
sudo service zfs-zed stop
# Check if the ZFS module is loaded
if lsmod | grep -q "^zfs"; then
    echo "ZFS module is loaded."
    sudo zpool destroy -f pool
    set -e
    sudo modprobe -r zfs
    # Perform actions when the ZFS module is loaded
else
    set -e
    echo "ZFS module is not loaded."
    # Perform actions when the ZFS module is not loaded
fi
sudo make uninstall
sudo ldconfig
sudo depmod
sudo rm -rf /usr/local/etc/zfs
sudo rm -rf /usr/lib/python3/dist-packages/libzfs_core

make -s -j$(nproc)

sudo make install
sudo ldconfig
sudo depmod

sudo ./scripts/zfs.sh -r
sudo systemctl enable zfs.target zfs-import.target \
    zfs-mount.service zfs-import-cache.service zfs-import-scan.service
sudo modprobe zfs
sudo service zfs-zed start

sudo rm -rf /media/ramdisk*

for i in {1..4}; do
    sudo mkdir -p /media/ramdisk$i
    # sudo mount -t tmpfs -o size=${size} tmpfs /media/ramdisk$i/
    sudo truncate -s ${size} /media/ramdisk$i/disk.img
done

sudo zpool create pool raidz /media/ramdisk1/disk.img /media/ramdisk2/disk.img /media/ramdisk3/disk.img
sudo zfs set mountpoint=/data/dataNode1 pool
sudo zfs mount
sudo chown -R aaronmao:aaronmao /data/dataNode1
dd if=/dev/urandom of=/data/dataNode1/newfile bs=2M count=1

printf "=======\nAll commands ran successfully\n=======" 
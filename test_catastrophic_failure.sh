#!/bin/bash
# size=$1

# sudo rm -rf /media/ramdisk*

# for i in {1..4}; do
#     sudo mkdir -p /media/ramdisk$i
#     # sudo mount -t tmpfs -o size=${size} tmpfs /media/ramdisk$i/
#     sudo truncate -s ${size} /media/ramdisk$i/disk.img

#     # The following are for creating loopback for 
#     # # We have already created the file image through truncate
#     # # Partition the image file
#     # sudo cfdisk /media/ramdisk$i/disk.img

#     # # Create loop back (pad out the loop back index by 20 since the device might already have a few loop back
#     # loopback_num=$(($i+20))
#     # sudo losetup -P /dev/loop$loopback_num /media/ramdisk$i/disk.img

#     # sudo mkfs.ext4 /dev/loop$loopback_num
# done

# Create the zpool
sudo zfs set mountpoint=/mnt/zfs pool
sudo chown -R aaronmao:aaronmao /mnt/zfs

# Create the zfs test file, of 400MB
for i in {1..6}; do
    cd /mnt/zfs && sudo dd if=/dev/random of=/mnt/zfs/test$i bs=40M count=10
done

sudo dd if=/dev/zero of=/media/ramdisk1/disk.img bs=4M count=20 2>/dev/null
sudo dd if=/dev/zero of=/media/ramdisk2/disk.img bs=4M count=20 2>/dev/null


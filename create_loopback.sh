#!/bin/bash
size=$1

for i in {1..4}; do
    # Create tmpfs
        sudo mkdir -p /media/rdisk$i
        sudo mount -t tmpfs -o size=${size} tmpfs /media/rdisk$i/
        sudo truncate -s ${size} /media/rdisk$i/disk.img

    # Install GPT table to the img
    cfdisk /media/rdisk$i/disk.img

    # Setup loopback device
    loopback_num=$(($i+20))
    losetup -P /dev/loop$loopback_num /media/rdisk$i/disk.img

    # # Format FS and mount
    # mkfs.ext4 /dev/loop$loopback_num
    # sudo mkdir -p /rdisk/ram$i
    # sudo mount /dev/loop$loopback_num /rdisk/ram$i
done

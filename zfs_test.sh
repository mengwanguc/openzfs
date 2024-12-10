# Test script to see what's going on

for i in {1..3}; do sudo truncate -s 4G /scratch/$i.img; done

sudo zpool create test raidz /scratch/1.img /scratch/2.img /scratch/3.img 
sudo dd if=/dev/zero of=/scratch/2.img bs=4M count=1 2>/dev/null
sudo zpool scrub zpool
sudo truncate -s 2G /scratch/new.img
sudo zpool replace zpool /scratch/2.img /scratch/new.img

sudo cat /proc/spl/kstat/zfs/dbgmsg > log.txt

sudo zpool destroy zpool
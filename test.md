# Test command
 
for i in {1..3}; do sudo truncate -s 2G /scratch/$i.img; done

sudo zpool create zpool raidz1 /scratch/1.img /scratch/2.img /scratch/3.img
sudo zpool create zpool mirror /scratch/1.img /scratch/2.img 


# simulate disk failures
sudo dd if=/dev/zero of=/scratch/2.img bs=4M count=1 2>/dev/null
sudo zpool scrub zpool
sudo truncate -s 2G /scratch/new.img
sudo zpool replace zpool /scratch/2.img /scratch/new.img

# change ownership 
sudo chown cc:cc /zpool/data

# check the log
sudo cat /proc/spl/kstat/zfs/dbgmsg

# delete the zpool
sudo zpool destroy zpool
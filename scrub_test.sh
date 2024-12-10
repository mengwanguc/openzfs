for i in {1..3}; do sudo truncate -s 4G /scratch/$i.img; done

sudo zpool create zpool raidz /scratch/1.img /scratch/2.img /scratch/3.img -f
sudo dd if=/dev/zero of=/scratch/2.img bs=4M count=1 2>/dev/null
#sudo dd if=/dev/zero of=/scratch/3.img bs=4M count=1 2>/dev/null
sudo zpool easyscrub zpool
zpool status

sudo cat /proc/spl/kstat/zfs/dbgmsg > log.txt
sudo zpool destroy zpool 

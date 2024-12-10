echo cfq > /sys/module/zfs/parameters/zfs_vdev_scheduler
echo "7:21 10485760" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
echo "7:22 10485760" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
echo "7:23 10485760" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
echo "7:24 10485760" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
dd if=/dev/zero of=/rampool/file1 bs=128M count=1
dd if=/dev/zero of=/rampool/file1 bs=128M count=1
dd if=/dev/zero of=/rampool/file1 bs=128M count=1
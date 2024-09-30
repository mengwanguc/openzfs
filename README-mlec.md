## Introduction
There are two main folder to look at
- `module`: this contains ZFS internal logics for MLEC repairs as well as error detections
- `cmd|lib`: contains all the changes for ioctl calls from HDFS

I will split the rest of the README according to the two components

## `ioctl` calls
We use `ioctl` for HDFS to
- `mlec_easy_scrub`: get all the failure information from ZFS through ZAP (ZFS attribute processor)
- `mlec_failed_chunks`: get all failed chunks in the zpool
- `mlec_receive_data`: receive binary array from HDFS, and conduct repair

### `mlec_easy_scrub` call chains and contents

This ioctl call checks for the child vdev(physical disks) of a top-level vdev(RAIDZ/CP), and return an array of int that represent their current status. A non-zero number will indicate error.

There are two **entry points** for this command, one from CMD (for debugging and impl), and one from `libzfs` C API
- `cmd/zpool/zpool_main.c`: this is the main entry point for CMD easy scrub that can be triggered via `zpool easyscrub <poolname>` command
- `lib/libzfs_core/libzfs_core.c`: this is the entry point for `libzfs` C API, and hence `libzfs-mlec-binding` Java binding

The above two entry points are all handled within ZFS's ioctl handler class.
- `module/zfs/zfs_ioctl.c`: this is where all the logics for `mlec_easy_scrub` lies, in function `zfs_ioc_pool_easy_scan`

The main logic of `mlec_easy_scrub` is the loop over of the vdev children and the calling of `vdev_open`, which will return a non-zero code if the vdev cannot be opened.

### `mlec_failed_chunks` call chains and contents

If `mlec_easy_scrub` returns error code, we can then call `mlec_failed_chunks` to get the dnode number of the files that are impacted by the failed chunks.

Same as `mlec_easy_scrub`, there are two entry points, one for CMD and one for `libzfs` C API. They are located in the same file as `mlec_easy_scrub`.

Same as `mlec_easy_scrub`, the two entry points are handled in `module/zfs/zfs_ioctl.c` but in the function `zfs_ioctl_failed_chunks`

The main logic of failed chunks is in `mlec_dump_objset`. Where we loop through all the dnodes in the zpool passed in from the entry points, and then return its attributes through `nvlist` that will be translated to `DnodeAttributes.java` in the Java binding project.

Note: the `fsize` logic is still kind of buggy, due to SA handle setup is a very complicated process. I have currently commented it out, but we would need to enable this for the whole repair process to work correctly.

### `mlec_receive_data` call chains and contents.

This ioctl call takes a dnode number, and a binary array from the C API, and override the ARC buffer of the RAIDZ columns.

Different from `mlec_easy_scrub`, there is no point in providing a CMD interface to a data-plane API. Therefore, the entry point for the call only resides in `lib/libzfs_core/libzfs_core.c`

The main logic of `mlec_receive_data` is basically as follows
1. We acquire the `dnode` struct from the input through ZAP
2. We copy the input binary array into ZFS data structure through `abd_alloc_for_io` and `abd_copy_from_buf` 
3. We then initiate a ZIO through `zio_root` and `zio_ioctl`, which will write the data through internal logics that I will talk about in the following sections.

## Internal Logics
Although most of the logics are done in the ioctl handler, we had to make a few changes to ZFS internal logics so that we can have special MLEC repair code paths.

### MLEC specific repair data
Normal ZIO requires setups that are complex and unnecessary for MLEC. Since for MLEC we are only interested in getting the received data directly into column ARC buffer, we developed a specialized ZIO pipeline.

1. We first have added a new ZIO type in `include/sys/fs/zfs.h` called `ZIO_TYPE_MLEC_WRITE_DATA`
2. We added in `module/zfs/zio.c`'s function `zio_ioctl` a special `if` case for `ZIO_TYPE_MLEC_WRITE_DATA`
3. We added custom adb logic in `module/zfs/zio.c`'s function `zio_vdev_io_start` to handle ZIO that are MLEC repair
4. We added custom logic in `module/zfs/vdev_raidz.c` to handle MLEC data physical write in `vdev_raidz_io_start`
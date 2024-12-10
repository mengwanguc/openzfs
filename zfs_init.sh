# Script the initialize zfs

#------------------------Set up environment and compile-------------------------
sudo apt-get update
sudo apt install build-essential autoconf automake libtool gawk alien fakeroot \
    dkms libblkid-dev uuid-dev libudev-dev libssl-dev zlib1g-dev libaio-dev \
    libattr1-dev libelf-dev linux-headers-generic python3 python3-dev \
    python3-setuptools python3-cffi libffi-dev python3-packaging git \
    libcurl4-openssl-dev debhelper-compat dh-python po-debconf python3-all-dev \
    python3-sphinx

sudo apt-get install linux-image-generic

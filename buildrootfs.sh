#!/bin/bash
#

STORAGE=$HOME/storage/rootfs
BUILD=0

if [ $(ls -1 $STORAGE |wc -l) -lt 8 ]; then
    BUILD=1
fi

cd $HOME/buildroot-ci
git fetch
if ! [ "$(git rev-parse HEAD)" == "$(git rev-parse @{u})" ]; then
    BUILD=1
fi

if [ $BUILD -eq 1 ]; then
    git pull

    echo "Building rootfs"
    if ./build_rootfs.sh defconfig armv4 build armv4 defconfig armv5 build armv5 defconfig armv7 build armv7 defconfig aarch64 build aarch64
    then
        echo "Rootfs built!"
        exit 0
    else
        echo "Rootfs building failed"
        exit 1
    fi
else
    echo "Nothing to update"
    exit 0
fi



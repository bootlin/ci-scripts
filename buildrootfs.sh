#!/bin/bash
#

STORAGE=$HOME/storage/rootfs
BUILD=0
LAST_BUILD=$HOME/last_build.txt

if [ $(ls -1 $STORAGE |wc -l) -lt 8 ]; then
    BUILD=1
fi

cd $HOME/buildroot-ci
git fetch
if ! [ "`cat $LAST_BUILD`" == "$(git rev-parse @{u})" ]; then
    BUILD=1
fi

if [ $BUILD -eq 1 ]; then
    git pull

    echo "Building rootfs"
    if ./build_rootfs.sh defconfig armv4 build armv4 defconfig armv5 build armv5 defconfig armv7 build armv7 defconfig aarch64 build aarch64 2>&1
    then
        echo "Rootfs built!"
        echo $(git rev-parse HEAD) > $LAST_BUILD
        exit 0
    else
        echo "Rootfs building failed"
        exit 1
    fi
else
    echo "Nothing to update"
    exit 0
fi


